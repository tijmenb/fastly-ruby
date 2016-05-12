require "fastly/version"

require "logger"
require "securerandom"

require "cistern"
require "faraday"
require "faraday_middleware"
require "faraday/detailed_logger"

module Fastly
  include Cistern::Client

  USER_AGENT = "Fastly/#{Fastly::VERSION} Ruby/#{RUBY_VERSION} (#{RUBY_PLATFORM}; #{RUBY_ENGINE}"

  recognizes :username, :password, :token, :url, :adapter, :logger
end

require "fastly/token_middleware"
require "fastly/response"
require "fastly/request"
require "fastly/collection"

require "fastly/customer"
require "fastly/customers"
require "fastly/get_customer"
require "fastly/get_current_customer"

require "fastly/get_service"
require "fastly/get_services"
require "fastly/create_service"
require "fastly/destroy_service"
require "fastly/update_service"
require "fastly/search_services"

require "fastly/service"
require "fastly/services"
require "fastly/version_model"
require "fastly/versions"

require "fastly/real"
require "fastly/mock"
