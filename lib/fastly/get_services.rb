class Fastly::GetServices < Fastly::Request
  request_method :get
  request_path { |r| "/service" }

  def mock
    services = service.data[:services].values.
      select { |s| s["customer_id"] == service.current_customer.identity && s["deleted_at"].nil? }.
      each   { |s| s["versions"] = service.data[:service_versions][s["id"].to_i].values }

    mock_response(services)
  end
end
