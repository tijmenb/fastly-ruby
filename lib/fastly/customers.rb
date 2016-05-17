class Fastly::Customers
  include Fastly::Collection

  model Fastly::Customer

  def all(*args)
    raise NotImplementedError
  end

  def current
    new(
      cistern.get_current_customer.body
    )
  end

end
