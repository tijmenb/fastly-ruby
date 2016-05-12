class Fastly::Versions < Fastly::Collection

  model Fastly::Version

  attribute :service_id

  def all
    requires :service_id

    load(
      service.get_versions(service_id).body
    )
  end

  def get(identity)
    requires :service_id

    new(
      service.get_version(service_id, identity).body
    )
  end

  def new(attributes={})
    attributes[:service_id] ||= service_id
    super
  end

end
