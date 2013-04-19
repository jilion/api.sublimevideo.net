source 'https://rubygems.org'
source 'https://8dezqz7z7HWea9vtaFwg@gem.fury.io/me/' # thibaud@jilion.com account

ruby '2.0.0'

# DB
gem 'pg'

# Internals
gem 'activesupport', '4.0.0.beta1'
gem 'actionpack',    '4.0.0.beta1'
gem 'activerecord',  '4.0.0.beta1'
gem 'oj'

# API framework
gem 'sublime_video_private_api', '~> 1.3' # hosted on gemfury
gem 'grape'
gem 'grape-rabl'
gem 'kaminari'

group :staging, :production do
  gem 'unicorn'
  gem 'rack-ssl'
  gem 'rack-status'
  # gem 'lograge'
  gem 'dalli'
  # gem 'rack-cache'
  gem 'newrelic_rpm'
  gem 'honeybadger'
  # gem 'librato-rails', github: 'librato/librato-rails', branch: 'feature/rack_first'
end

group :development do
  gem 'portugal'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
end

group :tools do
  gem 'ruby_gntp'
  gem 'rb-fsevent'
  gem 'guard-rspec'
end
