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

  def create
    requires :service_id, :version_number, :name

    response = cistern.create_domain(service_id, version_number, attributes)
    merge_attributes(response.body)
  end

  def save
    requires :service_id, :version_number, :identity

    response = cistern.update_domain(service_id, version_number, name, attributes)
    merge_attributes(response.body)
  end
end
