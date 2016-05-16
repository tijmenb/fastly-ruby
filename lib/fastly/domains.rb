class Fastly::Domains < Fastly::Collection

  model Fastly::Domain

  attribute :service_id
  attribute :version

  def all
    requires :service_id, :version

    load(
      service.get_domains(service_id).body
    )
  end

  def get(identity)
    requires :service_id, :version

    new(
      service.get_domains(service_id, identity).body
    )
  end

  def new(attributes={})
    attributes[:service_id] ||= service_id
    attributes[:version] ||= version
    super
  end

end
