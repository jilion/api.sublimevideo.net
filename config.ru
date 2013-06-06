# This file is used by Rack-based servers to start the application.
require File.expand_path('config/boot', __dir__)

# Exceptions handler
use Honeybadger::Rack

if ENV['RACK_ENV'] == 'production'
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

# Metrics
require 'librato-rack'
use Librato::Rack, config: Librato::Rack::Configuration.new

# Sets an 'Etag' and 'Cache-Control' response headers
use Rack::ETag

# Sets an 'X-Runtime' response header
use Rack::Runtime

require 'rack/status'
use Rack::Status

# Instrumentation
NewRelic::Agent.manual_start

# Application setup
require 'api/engine'
run SublimeVideo::API::Engine

# Display the middleware stack (run `be rackup` to see it)
if ENV['RACK_ENV'] == 'development'
  $logger.info "Middleware stack:\n#{@use.inject('') { |a,e| a << "#{e.call.class}\n" }}"
end
