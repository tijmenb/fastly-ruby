require 'spec_helper'

RSpec.describe "Versions" do
  it "creates a version" do
    service = a_service
    latest = service.versions.last
    version = service.versions.create

    expect(version.number).to eq(latest.number + 1)
  end

  describe "with a version" do
    let!(:version) { a_version }
    let!(:service) { version.service }

    it "fetches the version" do
      expect(client.versions(service_id: version.service_id).get(version.identity)).to eq(version)
    end

    #it "lists services" do
      #expect(client.services).to include(service)
    #end

    #it "deletes a service" do
      #service.destroy
      #expect(client.services.get(service.identity).deleted_at).not_to be_nil
      #expect(client.services).not_to include(service)
    #end

    #it "updates a service" do
      #new_name = SecureRandom.hex(6)
      #service.update(name: new_name)
      #expect(new_name).to eq(service.name)
      #expect(new_name).to eq(service.reload.name)
    #end

    #it "searches for services" do
      #service_count = client.services.all.size
      #upper = [service_count, 0].min
      #seed_size = [upper, 0].max
      #seed_size.times { create_service }
      #found_service = client.services.first(name: service.name)
      #expect(found_service).to eq(service)
    #end
  end
end
