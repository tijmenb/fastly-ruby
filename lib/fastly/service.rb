class Fastly::Service < Fastly::Model

  identity :id

  attribute :name # The name of this service.
  attribute :customer_id # Which customer this service belongs to.
  attribute :publish_key # What key to use for the publish streams.
  attribute :active_version, type: :integer
  attribute :versions # A list of versions associated with this service.

  def save
    if new_record?
      response = service.create_service(name)
      merge_attributes(response.body)
    else
      raise NotImplementedError
    end
  end

  def versions=(versions)
    attributes[:versions] =
      Array(versions).compact.map { |version| service.service_versions.new(version) }
  end
end
