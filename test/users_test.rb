require File.expand_path("../test_helper", __FILE__)

describe "Users" do
  let(:client) { create_client }

  it "fetches the current customer" do
    if Fastly.mocking?
      assert_equal client.current_customer, client.customers.current
    else
      refute_nil client.customers.current.identity
    end
  end

  it "fetches a specific customer" do
    assert_equal client.customers.current, client.customers.get(client.customers.current.identity)
  end
end
