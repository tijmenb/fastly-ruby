class Fastly::Services < Fastly::Collection

  model Fastly::Service

  def all(*args)
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
