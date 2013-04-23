# This file is used by Rack-based servers to start the application.
require File.expand_path('config/boot', __dir__)

if %w[staging production].include?(ENV['RACK_ENV'])
  require 'rack/ssl'
  use Rack::SSL
end

# redis-activesupport is not compatible with activesupport 4 yet...
# see https://github.com/jodosha/redis-store/issues/160
#
# require 'rack/attack'
# require 'redis-activesupport'
# use Rack::Attack
# ActiveSupport::Cache.lookup_store :redis_store
# Rack::Attack.cache.store = ActiveSupport::Cache::RedisStore.new
# Rack::Attack.throttle('req/ip', limit: 5_000, period: 1.hour) do |req|
#   req.ip
# end

# Monitoring
require 'librato-rack'
use Librato::Rack, config: Librato::Rack::Configuration.new

require 'rack/status'
use Rack::Status

# Application setup
require File.expand_path('api/engine', __dir__)
run SublimeVideo::API::Engine
