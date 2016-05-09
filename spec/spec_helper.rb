ENV["MOCK_FASTLY"] ||= "true"

Bundler.require(:test)

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fastly'

Dir[File.expand_path('../{support,shared,matchers,fixtures}/*.rb', __FILE__)].each { |f| require(f) }

if ENV["MOCK_FASTLY"] == "true"
  Fastly.mock!
end
