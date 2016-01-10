require File.expand_path("../test_helper", __FILE__)

describe "Users" do
  let(:client) { create_client }

  it "fetches the current customer" do
    if Fastly.mocking?
      assert_equal client.customer, client.customers.current
    else
      assert_not_nil client.customers.current.identity
    end
  end
end
