source 'https://rubygems.org'
source 'https://8dezqz7z7HWea9vtaFwg@gem.fury.io/me/' # thibaud@jilion.com account

ruby '2.0.0'

# Internals
gem 'actionpack', '4.0.0.rc.1'
gem 'activesupport', '4.0.0.rc.1'
gem 'activemodel', '4.0.0.rc.1'
gem 'oj'

# API
gem 'grape'
gem 'grape-rabl'
gem 'sublime_video_private_api', '~> 1.4' # hosted on gemfury
gem 'kaminari'

# Monitoring
gem 'rack-status'
gem 'grape-librato'
gem 'newrelic-grape', github: 'jilion/newrelic-grape', branch: 'avoid-autostart'

# Logging
gem 'lumberjack'

group :production do
  gem 'unicorn'
  gem 'rack-ssl'
  gem 'memcachier'
  gem 'dalli'
  gem 'honeybadger'
end

group :development, :test do
  gem 'dotenv'
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
