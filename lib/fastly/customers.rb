class Fastly::Customers < Fastly::Collection

  model Fastly::Customer

  def all(*args)
    raise NotImplementedError
  end

  def current
    new(
      service.get_current_customer.body
    )
  end

end
