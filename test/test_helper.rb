ENV["MOCK_FASTLY"] ||= "true"

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fastly'

require 'minitest/autorun'
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

Dir[File.expand_path('../{support,shared,matchers,fixtures}/*.rb', __FILE__)].each { |f| require(f) }


if ENV["MOCK_FASTLY"] == "true"
  Fastly.mock!
end
