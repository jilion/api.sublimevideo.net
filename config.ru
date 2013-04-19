# This file is used by Rack-based servers to start the application.

require ::File.expand_path('config/boot', __dir__)

if %w[staging production].include?(ENV['RACK_ENV'])
  require 'rack/ssl'
  use Rack::SSL
end

require 'rack/status'
use Rack::Status

run SublimeVideo::API
