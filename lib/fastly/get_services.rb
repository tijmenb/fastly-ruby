class Fastly::GetServices < Fastly::Request
  request_method :get
  request_path { |r| "/service" }

  def mock
    services = self.data[:services].select { |service|
      service["customer_id"] == service.current_customer.identity
    }.map { |service|
      service["versions"] = self.data[:service_versions][service["id"]].values
    }

    mock_response(services)
  end
end
