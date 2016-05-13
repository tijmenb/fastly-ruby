class Fastly::UpdateVersion < Fastly::Request

  request_method :put
  request_path { |r| "/service/#{r.service_id}" }
  request_params { |r| r.updated_attributes }

  parameter :service_id
  parameter :number
  parameter :attributes

  def self.accepted_parameters
    %w[comment testing staging deployed]
  end

  def mock
    find!(:services, service_id)
    version = service.data[:service_versions][service_id].fetch(number.to_i)
    version.merge!(updated_attributes.merge("updated_at" => Time.now.iso8601))

    mock_response(version)
  end
end
