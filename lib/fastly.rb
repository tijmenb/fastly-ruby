require "fastly/version"

require "cistern"
require "faraday"
require "faraday_middleware"
require "faraday-detailed_logger"

module Fastly
  include Cistern::Client

  recognizes :username, :password, :token, :url, :adapter, :logger
end

require "fastly/real"
require "fastly/mock"
