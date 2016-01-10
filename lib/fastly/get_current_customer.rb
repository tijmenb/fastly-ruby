class Fastly::GetCurrentCustomer < Fastly::Request
  request_method :get
  request_path { |_| "/current_customer" }

  def mock
    mock_response("customer" => find!(:customers, service.current_customer_id))
  end
end
