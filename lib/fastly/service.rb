class Fastly::Service < Fastly::Model

  identity :id

  attribute :name # The name of this service.
  attribute :customer_id # Which customer this service belongs to.
  attribute :publish_key # What key to use for the publish streams.
  attribute :active_version, type: :integer
  attribute :versions, parser: ->(v,_) { Array(v).map { service.service_versions.new(v) } } # A list of versions associated with this service.

  def save
    if new_record?
      service.create_service(name)
    else
      raise NotImplementedError
    end
  end

end
