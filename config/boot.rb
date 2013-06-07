ENV['RACK_ENV'] ||= 'development'

$:.push File.expand_path('..', __dir__)

require 'rubygems'
require 'bundler'
Bundler.setup(:default, ENV['RACK_ENV'])

if %w[development test].include?(ENV['RACK_ENV'])
  require 'dotenv'
  Dotenv.load
end

# API
require 'config/initializers/grape'

# Views
require 'config/initializers/rabl'

# Memcache
require 'dalli'

# Models
require 'config/initializers/models'

# Exceptions handler
require 'config/initializers/honeybadger'

# Logging
require 'config/initializers/lumberjack'
