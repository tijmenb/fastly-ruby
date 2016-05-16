class Fastly::Domain < Fastly::Model
  include Fastly::ServiceVersionModel

  identity :id, alias: 'name', type: :string

  attribute :comment, type: :string                           # A personal freeform descriptive note.
  attribute :name, type: :string                              # The name of the domain or domains associated with this service.
  attribute :service_id, type: :string                        # The alphanumeric string identifying a service.
  attribute :version_number, type: :integer, alias: 'version' # The current version of a service.

  def reload
    requires :service_id, :version, :identity

    @_service = nil
    @_version = nil

    merge_attributes(
      cistern.domains(service_id: service_id, version: version).get(identity).attributes
    )
  end

  def save
    new_attributes = if new_record?
                       requires :service_id, :version, :name

                       cistern.create_domain(service_id, version_number, attributes).body
                     else
                       requires :service_id, :version, :identity

                       cistern.update_domain(service_id, version_number, name, attributes).body
                     end
    merge_attributes(new_attributes)
  end
end
