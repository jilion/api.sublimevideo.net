source 'https://rubygems.org'
source 'https://8dezqz7z7HWea9vtaFwg@gem.fury.io/me/' # thibaud@jilion.com account

ruby '2.0.0'

# Internals
gem 'activesupport', '4.0.0.beta1'
gem 'oj'

# API
# gem 'rack-attack'
# gem 'redis-activesupport', '~> 3.2'
gem 'grape'
gem 'grape-rabl'
gem 'sublime_video_private_api', '~> 1.3' # hosted on gemfury
gem 'kaminari'

# Monitoring
gem 'rack-status'
gem 'grape-librato'
gem 'newrelic-grape'

# Logging
gem 'lumberjack'

group :staging, :production do
  gem 'unicorn'
  gem 'rack-ssl'
  gem 'dalli'
  gem 'honeybadger'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
end

group :tools do
  gem 'ruby_gntp'
  gem 'guard-rspec'
  gem 'yard'
  gem 'powder'
end
