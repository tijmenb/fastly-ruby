require 'spec_helper'

RSpec.describe "Users" do
  let(:client) { create_client }

  it "fetches the current customer" do
    if Fastly.mocking? then
      expect(client.customers.current).to eq(client.current_customer)
    else
      refute_nil(client.customers.current.identity)
    end
  end

  it "fetches a specific customer" do
    expect(client.customers.get client.customers.current.identity).to eq(client.customers.current)
  end
end
