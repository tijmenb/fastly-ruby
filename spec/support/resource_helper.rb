module ServiceHelper
  def create_service(options={})
    name = options.fetch(:name, SecureRandom.hex(8))

    client.services.create(name: name)
  end
end

RSpec.configure { |config| config.include(ServiceHelper) }
