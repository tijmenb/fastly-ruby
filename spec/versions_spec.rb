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

    it "lists versions" do
      expect(client.versions(service_id: a_version.service_id)).to include(version)
    end

    it "updates a version" do
      comment = SecureRandom.hex(6)

      version.update(comment: comment)

      expect(version.comment).to eq(comment)
      expect(version.reload.comment).to eq(comment)
    end
  end
end
