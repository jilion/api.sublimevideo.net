ENV['RACK_ENV'] ||= 'test'

require ::File.expand_path('../config/boot', __dir__)
require 'rack/test'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run_including focus: true
  config.mock_with :rspec
  config.fail_fast = ENV['FAST_FAIL'] != 'false'
  config.order = ENV['ORDER'] || 'random'
end

Dir[File.join(__dir__, 'support/**/*.rb')].each { |f| require f }
