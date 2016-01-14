class Fastly::ServiceVersion < Fastly::Model

  identity :id, alias: "number", type: :integer

  attribute :active,     type: :boolean #   Whether this is the active version or not.
  attribute :comment
  attribute :created_at, type: :time
  attribute :deleted_at, type: :time
  attribute :deployed,   type: :boolean
  attribute :locked,     type: :boolean # Whether this version is locked or not. Objects can not be added or edited on locked versions.
  attribute :number,     type: :integer #  The number of this version.
  attribute :service_id
  attribute :staging,    type: :boolean
  attribute :testing,    type: :boolean
  attribute :updated_at, type: :time

  def service
    @service ||= client.services.get(service_id)
  end

  def reload
    @service = nil
    super
  end

end
