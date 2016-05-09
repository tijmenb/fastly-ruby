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
    matched_service = service.data[:services].values.find { |s| Cistern::Hash.slice(s, *search_params.keys) == search_params }

    matched_service["customer_id"] == service.current_customer.identity
    matched_service["versions"] = service.data[:service_versions][matched_service["id"].to_i].values

    mock_response(matched_service)
  end
end
