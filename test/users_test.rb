require File.expand_path("../test_helper", __FILE__)

describe "Users" do
  let(:customer) { create_customer }
  let(:client)   { create_client(customer: customer) }

  it "fetches the current customer" do
    assert_equal customer, client.customers.current
  end
end
