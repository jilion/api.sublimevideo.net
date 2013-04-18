# This file is used by Rack-based servers to start the application.

require ::File.expand_path('config/boot', __dir__)

if %w[staging production].include?(ENV['RACK_ENV'])
  require 'rack/ssl'
  require 'rack/status'
  use Rack::SSL
  use Rack::Status
end

require 'rack/oauth2_access_token_type_name_proxy'
use Rack::OAuth2AccessTokenTypeNameProxy

require 'rack/oauth2'
use Rack::OAuth2::Server::Resource::Bearer, 'SublimeVideo Protected Resources' do |req|
  Oauth2Token.valid.where(token: req.access_token).first || req.invalid_token!
end

run SublimeVideo::API
