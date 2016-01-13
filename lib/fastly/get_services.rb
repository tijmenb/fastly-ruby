class Fastly::GetServices < Fastly::Request
  request_method :get
  request_path { |r| "/service" }

  def mock
    mock_response(find!(:services))
  end
end
