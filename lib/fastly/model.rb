class Fastly::Model
  def self.has_many(name, scope)
    reader_method = name
    writer_method = "#{name}="

    define_method reader_method do
      attributes[name] || instance_exec(&scope)
    end

    define_method writer_method do |models|
      attributes[name] ||= instance_exec(&scope).load(
        models.map { |model| model.respond_to?(:attributes) ? model.attributes : model }
      )
    end
  end
end
