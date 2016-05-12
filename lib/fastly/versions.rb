class Fastly::Versions < Fastly::Collection

  model Fastly::Version

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
