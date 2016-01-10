class Fastly::Request
  def self.request_method(request_method=nil)
    @request_method ||= request_method
  end

  def self.request_params(&block)
    @request_params ||= block
  end

  def self.request_body(&block)
    @request_body ||= block
  end

  def self.request_path(&block)
    @request_path ||= block
  end

  attr_reader :params

  def setup(params)
    @params = Cistern::Hash.stringify_keys(params)
  end

  def _mock(params={})
    setup(params)
    mock
  end

  def _real(params={})
    setup(params)
    real
  end

  def request_params
    if self.class.request_params
      self.class.request_params.call(self)
    else
      {}
    end
  end

  def request_path
    case (generator = self.class.request_path)
    when Proc then
      generator.call(self)
    else raise ArgumentError.new("Couldn't generate request_path from #{generator.inspect}")
    end
  end

  def request_body
    case (generator = self.class.request_body)
    when Proc then
      generator.call(self)
    when NilClass then nil
    else raise("Invalid request body generator: #{generator.inspect}")
    end
  end

  def pluralize(word)
    pluralized = word.dup
    [[/y$/, 'ies'], [/$/, 's']].find{|regex, replace| pluralized.gsub!(regex, replace) if pluralized.match(regex)}
    pluralized
  end

  def data
    self.service.data
  end

  def url_for(path, options={})
    URI.parse(
      File.join(service.url, path.to_s)
    ).tap do |uri|
      if query = options[:query]
        uri.query = Faraday::NestedParamsEncoder.encode(query)
      end
    end.to_s
  end

  def real(params={})
    service.request(:method => self.class.request_method,
                    :path   => self.request_path,
                    :body   => self.request_body,
                    :url    => params["url"],
                    :params => self.request_params,
                   )
  end

  def real_request(params={})
    request({
      :method => self.class.request_method,
      :path   => self.request_path(params),
      :body   => self.request_body(params),
    }.merge(cistern::hash.slice(params, :method, :path, :body, :headers)))
  end

  def mock_response(body, options={})
    response(
      :method        => self.class.request_method,
      :path          => options[:path]    || self.request_path,
      :request_body  => self.request_body,
      :response_body => body,
      :headers       => options[:headers] || {},
      :status        => options[:status]  || 200,
      :params        => options[:params]  || self.request_params,
    )
  end

  def find!(collection, identity, options={})
    if resource = self.service.data[collection][identity]
      resource
    else
      error!(options[:error] || :not_found, options)
    end
  end

  def mock_response(options={})
    body   = options[:response_body] || options[:body]
    method = options[:method]        || :get
    params = options[:params]
    status = options[:status]        || 200

    path = options[:path]
    url  = options[:url] || url_for(path, query: params)

    request_headers  = {"Accept"       => "application/json"}
    response_headers = {"Content-Type" => "application/json; charset=utf-8"}

    # request phase
    # * :method - :get, :post, ...
    # * :url    - URI for the current request; also contains GET parameters
    # * :body   - POST parameters for :post/:put requests
    # * :request_headers

    # response phase
    # * :status - HTTP response status code, such as 200
    # * :body   - the response body
    # * :response_headers
    env = Faraday::Env.from(
      :method           => method,
      :url              => URI.parse(url),
      :body             => body,
      :request_headers  => request_headers,
      :response_headers => response_headers,
      :status           => status,
    )

    Faraday::Response::RaiseError.new.on_complete(env) ||
      Faraday::Response.new(env)
  rescue Faraday::Error::ClientError => e
    raise Fastly::Error.new(e)
  end
end
