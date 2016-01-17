class Fastly::Services < Fastly::Collection

  model Fastly::Service

  def all(options={})
    resources = if options.empty?
                  service.get_services.body
                else
                  [service.search_services(options).body]
                end

    load(resources)
  end

  def get(identity)
    new(
      service.get_service(identity).body
    )
  rescue Fastly::Response::BadRequest
    nil
  end

end
