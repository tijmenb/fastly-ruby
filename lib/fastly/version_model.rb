class Fastly::Version < Fastly::Model

  identity :id, alias: "number", type: :integer

  attribute :active,           type: :boolean # Whether this is the active version or not.
  attribute :backends,         type: :array
  attribute :cache_settings,   type: :array
  attribute :comment
  attribute :conditions,       type: :array
  attribute :created_at,       type: :time
  attribute :deleted_at,       type: :time
  attribute :deployed,         type: :boolean
  attribute :directors,        type: :array
  attribute :domains,          type: :array
  attribute :gzips,            type: :array
  attribute :headers,          type: :array
  attribute :healthchecks,     type: :array
  attribute :locked,           type: :boolean # Whether this version is locked or not. Objects can not be added or edited on locked versions.
  attribute :matches,          type: :array
  attribute :number,           type: :integer # The number of this version.
  attribute :origins,          type: :array
  attribute :request_settings, type: :array
  attribute :response_objects, type: :array
  attribute :service_id
  attribute :settings
  attribute :staging,          type: :boolean
  attribute :testing,          type: :boolean
  attribute :updated_at,       type: :time
  attribute :vcls,             type: :array
  attribute :wordpress,        type: :array

  attr_reader :cistern

  def service
    @_service ||= begin
                    requires :service_id

                    cistern.services.get(service_id)
                  end
  end

  def reload
    requires :service_id, :identity
    @_service = nil
    merge_attributes(
      cistern.versions(service_id: service_id).get(identity).attributes
    )
  end

  def save
    new_attributes = if new_record?
                       cistern.create_version(service_id, attributes).body
                     else
                       cistern.update_version(service_id, number, attributes).body
                     end
    merge_attributes(new_attributes)
  end

  private

  def merge_attributes(new_attributes={})
    @cistern ||= new_attributes.delete(:service)
    super(new_attributes)
  end

end
