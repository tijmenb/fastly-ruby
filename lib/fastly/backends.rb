class Fastly::Backends
  include Fastly::Collection

  model Fastly::Backend

  attribute :service_id
  attribute :version, type: :integer

  def all
    requires :service_id, :version

    load(
      cistern.get_backends(service_id, version).body
    )
  end

  def get(identity)
    requires :service_id, :version

    new(
      cistern.get_backend(service_id, version, identity).body
    )
  end

  def new(attributes={})
    attributes[:service_id] ||= service_id
    attributes[:version] ||= version
    super
  end

  def create(**attributes)
    new(attributes).tap(&:create)
  end

end
