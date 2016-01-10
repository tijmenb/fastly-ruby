class Fastly::TokenMiddleware < Faraday::Middleware
  def initialize(app, token)
    super(app)

    @token = token
  end

  def call(request_env)
    request_env[:request_headers].merge!("Fastly-Key" => @token)

    @app.call(request_env)
  end
end
