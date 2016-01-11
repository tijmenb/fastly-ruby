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

    @url ||= "https://api.fastly.com"
    @adapter ||= Faraday.default_adapter

    @connection = Faraday.new(url: url) do |connection|
      # response
      connection.response :json, content_type: /\bjson/

      # request
      connection.request :multipart

      if via == :session
        connection.use :cookie_jar
      else
        connection.use Fastly::TokenMiddleware, token
      end

      # idempotency
      connection.request :retry,
        :max                 => 30,
        :interval            => 1,
        :interval_randomness => 0.2,
        :backoff_factor      => 2

      if logger
        connection.response :detailed_logger, logger
      end

      connection.adapter(*adapter)
    end
  end

  def request(options={})
    method      = options[:method] || :get
    request_url = File.join(url, options.fetch(:path))
    params      = options[:params] || {}
    body        = options[:body]
    headers     = {
      "User-Agent" => Fastly::USER_AGENT,
      "Accept"     => "application/json"
    }.merge(options[:headers] || {})

    response = connection.send(method) do |req|
      req.url(request_url)
      req.headers.merge!(headers)
      req.params.merge!(params)
      req.body = body
    end

    Fastly::Response.new(
      :status  => response.status,
      :headers => response.headers,
      :body    => response.body,
      :request => {
        :method  => method,
        :url     => request_url,
        :headers => headers,
        :body    => body,
        :params  => params,
      }
    ).raise!
  end

end
