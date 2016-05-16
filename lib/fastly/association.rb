module Fastly::Association
  def associations
    @associations ||= []
  end

  def has_many(name, scope)
    reader_method = name
    writer_method = "#{name}="

    attribute name, type: :array

    define_method reader_method do
      attributes[name] || instance_exec(&scope)
    end

    define_method writer_method do |models|
      attributes[name] = instance_exec(&scope).load(
        Array(models).map { |model| model.respond_to?(:attributes) ? model.attributes : model }
      )
    end

    associations << name
  end
end

Fastly::Model.extend(Fastly::Association)
