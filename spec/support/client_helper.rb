module ClientHelper
  def create_client(options={})
    via = options[:via] || :token
    client_options = {}

    case via
    when :token then
      token = options[:token]

      token ||= Fastly.mocking? ? SecureRandom.hex(20) : ENV.fetch("FASTLY_TOKEN")

      client_options.merge!(:token => token)
    when :credentials then
      username, password = options.values_at(:username, :password)

      username ||= Fastly.mocking ? SecureRandom.hex(6) : ENV.fetch("FASTLY_USERNAME")
      password ||= Fastly.mocking ? SecureRandom.hex(8) : ENV.fetch("FASTLY_PASSWORD")

      client_options.merge!(username: username, password: password)
    else
      raise ArgumentError, "unable to process via: #{via}"
    end

    if ENV["VERBOSE"]
      client_options.merge!(logger: Logger.new(STDOUT))
    end

    if ENV["FASTLY_URL"]
      client_options.merge!(url: ENV["FASTLY_URL"])
    end

    client = Fastly.new(client_options)

    if Fastly.mocking?
      client.current_customer = options.fetch(:customer, create_customer(client, options))
    end

    client
  end

  def create_customer(client, options={})
    if Fastly.mocking?
      customer = {
        "can_stream_syslog"       => nil,
        "owner_id"                => client.new_id,
        "can_upload_vcl"          => nil,
        "has_config_panel"        => nil,
        "raw_api_key"             => SecureRandom.hex(20),
        "name"                    => client.new_id,
        "id"                      => client.new_id,
        "can_configure_wordpress" => nil,
        "updated_at"              => Time.now.iso8601,
        "created_at"              => Time.now.iso8601,
        "can_reset_passwords"     => true,
        "pricing_plan"            => "customer",
        "billing_contact_id"      => nil
      }.merge(options[:customer] || {})

      client.data[:customers][customer.fetch("id")] = customer

      client.customers.new(customer)
    else
      raise NotImplementedError
    end
  end
end

RSpec.configure { |config| config.include(ClientHelper) }
