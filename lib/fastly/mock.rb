class Fastly::Mock

  def self.data
    @data ||= Hash.new { |h, url|
      h[url] = {
        :customers => {},
      }
    }
  end

  attr_reader :via, :logger, :adapter, :username, :password, :token, :url, :connection

  def initialize(options={})
    @username, @password, @token, @url, @adapter, @logger =
      options.values_at(:username, :password, :token, :url, :adapter, :logger)

    @url ||= "https://api.fastly.com"
  end

  attr_reader :current_customer_id

  def customer=(customer)
    @current_customer_id = customer.id
  end

  def data
    self.class.data[@url]
  end

  def reset
    data.clear
  end

  def self.reset
    data.clear
  end
end
