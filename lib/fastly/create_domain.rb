class Fastly::CreateDomain < Fastly::Request

  ACCEPTED_PARAMETERS = %w[ name comment ].freeze

  request_method :post
  request_path { |r| "/service/#{r.service_id}/version/#{r.number}/domain" }
  request_params { |r| r.updated_attributes }

  parameter :service_id
  parameter :number
  parameter :attributes

  def self.accepted_parameters
    ACCEPTED_PARAMETERS
  end

  def mock
    find!(:service_versions, service_id, number.to_i)

    domain = service.data[:domains][service_id][number.to_i][updated_attributes.fetch("name")] = updated_attributes

    mock_response(domain)
  end
end
