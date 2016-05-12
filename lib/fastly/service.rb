class Fastly::Service < Fastly::Model

  identity :id

  attribute :active_version, type: :integer
  attribute :created_at, type: :time
  attribute :customer_id # Which customer this service belongs to.
  attribute :deleted_at, type: :time
  attribute :name # The name of this service.
  attribute :publish_key # What key to use for the publish streams.
  attribute :updated_at, type: :time
  attribute :versions, type: :array
  attribute :version, type: :integer

  def destroy
    requires :identity

    new_attributes = service.destroy_service(identity).body
    merge_attributes(new_attributes)
  end

  def save
    new_attributes = if new_record?
                       service.create_service(name).body
                     else
                       service.update_service(identity, attributes).body
                     end
    merge_attributes(new_attributes)
  end

  def versions=(versions)
    attributes[:versions] = service.versions(service_id: identity).load(versions.map do |version|
      version.respond_to?(:attributes) ? version.attributes : version
    end)
  end
end
