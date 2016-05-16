class Fastly::GetBackends < Fastly::Request
  request_method :get
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/backend" }

  parameter :service_id
  parameter :number

  def mock
    mock_response(service.data.dig(:backends, service_id, number.to_i) || [])
  end
end
