require File.expand_path("../test_helper", __FILE__)

describe "Services" do
  let(:client) { create_client }

  it "creates a service" do
    service = client.services.create(name: "steve")
  end

  it "fetches a specific customer" do
    assert_equal client.customers.current, client.customers.get(client.customers.current.identity)
  end
end
