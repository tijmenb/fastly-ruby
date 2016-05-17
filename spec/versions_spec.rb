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

  describe "with a deactivated version" do
    let!(:version) { viable_version(active: false) }

    it "activates" do
      expect {
        version.activate!
      }.to change(version, :active).from(false).to(true)

      expect(version.reload).to be_active
    end
  end

  describe "with an activated version" do
    let!(:version) { viable_version(active: true) }

    it "deactivates" do
      expect {
        version.deactivate!
      }.to change(version, :active).from(true).to(false)

      expect(version.reload).not_to be_active
    end
  end
end