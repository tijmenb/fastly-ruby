class Fastly::Customers < Fastly::Collection

  model Fastly::Customer

  def all(*args)
    raise NotImplementedError
  end

  def current
    new(
      service.get_current_customer(identity).body
    )
  end

  def get(identity)
    new(
      service.get_customer(identity).body
    )
  end

end
