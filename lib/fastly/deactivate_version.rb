class Fastly::DeactivateVersion < Fastly::Request
  request_method :put
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/deactivate" }

  parameter :service_id
  parameter :number

  def mock
    find!(:services, service_id)

    service_versions = service.data[:service_versions][service_id]
    version = service_versions.fetch(number.to_i)
    version["active"] = false

    mock_response(version)
  end
end
