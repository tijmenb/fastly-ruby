module ClientHelper

  def create_client(options={})
    Fastly.new(options)
  end

  def create_customer(options={})
  end

end

Minitest::Spec.send(:include, ClientHelper)
