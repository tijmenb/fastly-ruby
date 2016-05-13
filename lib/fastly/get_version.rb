class Fastly::GetVersion < Fastly::Request
  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}" }

  parameter :service_id
  parameter :number

  def mock
    find!(:services, service_id)

    version = service.data[:service_versions][service_id].fetch(number.to_i)

    mock_response(version)
  end
end
