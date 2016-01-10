ENV["MOCK_FASTLY"] ||= "true"

Bundler.require(:test)
require 'minitest/autorun'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fastly'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

Dir[File.expand_path('../{support,shared,matchers,fixtures}/*.rb', __FILE__)].each { |f| require(f) }

if ENV["MOCK_FASTLY"] == "true"
  Fastly.mock!
end
