class Fastly::Real

  attr_reader :via, :logger, :adapter, :username, :password, :token, :url, :connection

  def initialize(options={})
    @username, @password, @token, @url, @adapter, @logger =
      options.values_at(:username, :password, :token, :url, :adapter, :logger)

    if !(token || "").empty?
      @via = :token
    elsif (username || "").empty? && (password || "").empty?
      raise ArgumentError, "missing token or [username, password]"
    else
      @via = :session
    end

    @adapter ||= Faraday.default_adapter

    @connection = Faraday.new(url: url) do |connection|
      # response
      connection.use Faraday::Response::RaiseError
      connection.response :json, content_type: /\bjson/

      # request
      connection.request :multipart

      if via == :session
        connection.use :cookie_jar
      else
        connection.use Fastly::TokenMiddleware
      end

      # idempotency
      connection.request :retry,
        :max                 => 30,
        :interval            => 1,
        :interval_randomness => 0.2,
        :backoff_factor      => 2

      if logger
        connection.use :detailed_logger, logger
      end

      connection.adapter(*adapter)
    end
  end

  def request(options={})
    method  = options[:method] || :get
    url     = options[:url] || File.join(@url, "/api/v2", options[:path])
    params  = options[:params] || {}
    body    = options[:body]
    headers = {"User-Agent" => Fastly::USER_AGENT}.merge(options[:headers] || {})

    connection.send(method) do |req|
      req.url(url)
      req.headers.merge!(headers)
      req.params.merge!(params)
      req.body = body
    end
  rescue Faraday::ConnectionFailed
    raise
  rescue Faraday::Error::ClientError => e
    raise Fastly::Error.new(e)
  end

end
