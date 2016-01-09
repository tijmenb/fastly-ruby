class Fastly::TokenMiddleware
  def initialize(app, token)
    @app, @token = app, token
  end

  def call(request_env)
    request_env[:request_headers].merge!("Fastly-Key" => @token)

    @app.call(request_env).on_complete { |response_env|  }
  end
end
