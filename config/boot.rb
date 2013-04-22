ENV['RACK_ENV'] ||= 'development'
# Bundler setup
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
Bundler.setup(:default, ENV['RACK_ENV']) if defined? Bundler

require 'yaml'
require 'grape'
require 'grape/rabl'
require 'kaminari/grape'
require 'sublime_video_private_api'
require 'lumberjack'


$:.push File.expand_path('../', __dir__)
$:.push File.expand_path('../lib', __dir__)

# Require models
Dir[File.expand_path('../app/models/**/*.rb', __dir__)].each do |file|
  dirname = File.dirname(file)
  file_basename = File.basename(file, File.extname(file))
  require "#{dirname}/#{file_basename}"
end

require 'rabl'
Rabl.configure do |config|
  # Commented as these are defaults
  # config.cache_all_output = false
  # config.cache_sources = Rails.env != 'development' # Defaults to false
  # config.cache_engine = Rabl::CacheEngine.new # Defaults to Rails cache
  # config.perform_caching = false
  # config.escape_all_output = false
  # config.json_engine = nil # Class with #dump class method (defaults JSON)
  # config.msgpack_engine = nil # Defaults to ::MessagePack
  # config.bson_engine = nil # Defaults to ::BSON
  # config.plist_engine = nil # Defaults to ::Plist::Emit
  # config.include_json_root = true
  # config.include_msgpack_root = true
  # config.include_bson_root = true
  # config.include_plist_root = true
  # config.include_xml_root  = false
  # config.include_child_root = true
  # config.enable_json_callbacks = false
  # config.xml_options = { :dasherize  => true, :skip_types => false }
  # config.view_paths = []
  # config.raise_on_missing_attribute = true # Defaults to false
end

$logger = Lumberjack::Logger.new("log/#{ENV['RACK_ENV']}.log")  # Open a new log file with INFO level

# Application setup
require File.expand_path('../app/api', __dir__)
