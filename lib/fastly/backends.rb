class Fastly::Backends < Fastly::Collection

  model Fastly::Backend

  attribute :service_id
  attribute :version

  def all
    requires :service_id, :version

    load(
      service.get_backends(service_id).body
    )
  end

  def get(identity)
    requires :service_id, :version

    new(
      service.get_backend(service_id, identity).body
    )
  end

  def new(attributes={})
    attributes[:service_id] ||= service_id
    attributes[:version] ||= version
    super
  end

end
