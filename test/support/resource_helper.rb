module ServiceHelper
  def create_service(options={})
    name = options.fetch(:name, SecureRandom.hex(8))

    client.services.create(name: name)
  end
end

Minitest::Spec.send(:include, ServiceHelper)
