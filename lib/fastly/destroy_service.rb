class Fastly::DestroyService < Fastly::Request
  request_method :delete
  request_path { |r| "/service/#{r.service_id}" }

  parameter :service_id

  def mock
    delete!(:services, service_id)
  end
end
