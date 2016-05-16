class Fastly::Model
  def self.has_many(name, block)
    define_method name do
      attributes[name] || instance_exec(&block)
    end

    define_method name do |models|
      attributes[name] ||= instance_exec(&block).load(
        models.map { |model| model.respond_to?(:attributes) ? model.attributes : model }
      )
    end
  end
end
