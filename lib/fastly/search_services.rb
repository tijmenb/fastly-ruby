class Fastly::SearchServices < Fastly::Request

  def self.search_params
    %w[name]
  end

  request_method :get
  request_path { |r| "/service/search" }
  request_params { |r| r.search_params }

  parameter :params

  def search_params
    Cistern::Hash.slice(Cistern::Hash.stringify_keys(params), *self.class.search_params)
  end

  def mock
    matched_services = service.data[:services].values.select { |s| Cistern::Hash.slice(s, *search_params.keys) == search_params }

    services = matched_services.
      select { |s| s["customer_id"] == service.current_customer.identity }.
      each   { |s| s["versions"] = service.data[:service_versions][s["id"].to_i].values }

    mock_response(services)
  end
end
