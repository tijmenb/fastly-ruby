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
  rescue Fastly::Response::BadRequest
    nil
  end

end
