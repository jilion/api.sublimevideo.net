#!/usr/bin/env rake
require 'portugal/tasks'
Portugal.configure do |config|
  config.migrations_path = File.expand_path('db/migrations', __dir__))
end

# This task is called before Portugal executes its tasks.
# It should require ActiveRecord somehow and establish the database connection
#
# Change it so it works for your application
task :environment do
  require 'bundler'
  Bundler.setup
  ActiveRecord::Base.establish_connection(database_config)
end

def database_config
  YAML.load_file(File.expand_path('config/database.yml', __dir__))[ENV['RACK_ENV']]
end
