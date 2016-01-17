ENV["MOCK_FASTLY"] ||= "true"

Bundler.require(:test)
require 'minitest/autorun'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fastly'

Minitest::Reporters.use!({
  "spec" => Minitest::Reporters::SpecReporter.new,
  "default" => Minitest::Reporters::DefaultReporter.new(:color => true),
}.fetch(ENV.fetch("REPORTER", "spec")))

Dir[File.expand_path('../{support,shared,matchers,fixtures}/*.rb', __FILE__)].each { |f| require(f) }

if ENV["MOCK_FASTLY"] == "true"
  Fastly.mock!
end
