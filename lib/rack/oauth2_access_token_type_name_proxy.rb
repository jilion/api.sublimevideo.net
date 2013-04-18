require 'rack'

module Rack
  class OAuth2AccessTokenTypeNameProxy

    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      @env = env

      # https://github.com/nov/rack-oauth2/blob/master/lib/rack/oauth2/server/resource.rb#L37
      auth_header = Rack::Auth::AbstractRequest.new(@env)

      # https://github.com/nov/rack-oauth2/blob/master/lib/rack/oauth2/server/resource/bearer.rb#L30
      @env[authorization_key] = "Bearer #{auth_header.params}" if auth_header.provided? && auth_header.scheme != 'oauth'

      @app.call(@env)
    end

    # https://github.com/rack/rack/blob/master/lib/rack/auth/abstract/request.rb#L32-L38
    private

    AUTHORIZATION_KEYS = ['HTTP_AUTHORIZATION', 'X-HTTP_AUTHORIZATION', 'X_HTTP_AUTHORIZATION']

    def authorization_key
      @authorization_key ||= AUTHORIZATION_KEYS.detect { |key| @env.has_key?(key) }
    end

  end
end
