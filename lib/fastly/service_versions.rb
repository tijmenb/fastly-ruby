class Fastly::ServiceVersions < Fastly::Collection

  model Fastly::ServiceVersion

  def all(service_id)
    load(
      service.get_services.body
    )
  end

  def get(identity)
    new(
      service.get_service(identity).body
    )
  end

end
