# This file is used by Rack-based servers to start the application.
require File.expand_path('config/boot', __dir__)

if %w[staging production].include?(ENV['RACK_ENV'])
  require 'rack/ssl'
  use Rack::SSL
end

# Monitoring
require 'librato-rack'
use Librato::Rack, config: Librato::Rack::Configuration.new

require 'rack/status'
use Rack::Status

# Application setup
require File.expand_path('api/engine', __dir__)
run SublimeVideo::API::Engine
