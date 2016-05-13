module ServiceHelper
  class << self
    attr_accessor :example_services, :services
  end

  def self.reset
    self.example_services = self.services
  end

  def self.service(validate: ->(r) { r.reload.deleted_at.nil? })
    self.services = yield unless services&.any?
    self.example_services = services unless example_services&.any?

    valid_service = nil

    while example_services.any? && valid_service.nil?
      resource = example_services.sample

      example_services.delete(resource)

      valid_service = resource if validate.call(resource)
    end

    valid_service
  end

  def create_service(options={})
    name = options.fetch(:name, SecureRandom.hex(8))

    client.services.create(name: name)
  end

  def a_service(options={})
    return create_service(options) if Fastly.mocking?
    cached_service = ServiceHelper.service { client.services.all }

    cached_service || create_service(options)
  end

  def a_version(options={})
    a_service.versions.sample
  end
end

RSpec.configure do |config|
  config.include(ServiceHelper)
  config.before(:each) { ServiceHelper.reset unless Fastly.mocking? }
end
