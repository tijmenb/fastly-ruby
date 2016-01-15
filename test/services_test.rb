require File.expand_path("../test_helper", __FILE__)

describe "Services" do
  let!(:client) { create_client }

  it "creates a service" do
    service_name = SecureRandom.hex(8)
    service = client.services.create(name: service_name)

    assert_equal service.name, service_name
  end

  describe "with a service" do
    let!(:service) { client.services.create(name: SecureRandom.hex(8)) }

    it "fetches the service" do
      assert_equal service, client.services.get(service.identity)
    end

    it "lists services" do
      assert_includes client.services.all, service
    end

    it "deletes a service" do
      service.destroy

      assert_nil client.services.get(service.identity)
      assert_nil service.reload
    end
  end
end
