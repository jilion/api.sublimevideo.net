source 'https://rubygems.org'
source 'https://8dezqz7z7HWea9vtaFwg@gem.fury.io/me/' # thibaud@jilion.com account

ruby '2.1.2'

# Internals
gem 'oj'

# API
gem 'grape'
gem 'grape-rabl'
gem 'sublime_video_private_api', '~> 1.6' # hosted on gemfury
gem 'kaminari'

# Monitoring
gem 'rack-status'
gem 'grape-librato'
gem 'newrelic_rpm'
gem 'newrelic-grape'

# Logging
gem 'lumberjack'
gem 'dalli'
gem 'honeybadger'
gem 'faraday', '~> 0.8.9'

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
  gem 'rack-ssl'
  gem 'memcachier'
end

group :development, :test do
  gem 'dotenv'
end

group :test do
  gem 'rack-test'
  gem 'rspec', '~> 2.14'
end

group :tools do
  gem 'ruby_gntp'
  gem 'guard-rspec'
  gem 'yard'
  gem 'powder'
end
