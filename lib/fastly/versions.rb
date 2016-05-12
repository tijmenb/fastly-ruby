class Fastly::Versions < Fastly::Collection

  model Fastly::Version

  attribute :service_id

  def all(service_id)
    self.service_id = service_id
    load(
      service.get_versions(service_id).body
    )
  end

  def get(service_id, identity)
    new(
      service.get_version(service_id, identity).body
    )
  end

  def new(attributes={})
    attributes[:service_id] ||= service_id
    super(attributes)
  end

end
