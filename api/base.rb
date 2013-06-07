module SublimeVideo
  module API
    module Base
      extend ActiveSupport::Concern

      included do
        use Rack::Config do |env|
          env['api.tilt.root'] = File.expand_path('views', __dir__)
        end

        require 'lib/grape/middleware/logger'
        use Grape::Middleware::Logger

        require 'grape-librato'
        use Librato::Grape::Middleware

        use Grape::Middleware::Auth::OAuth2, parameter: 'access_token',
                                             realm: 'SublimeVideo Protected Resources'

        default_format :json
        format :json
        formatter :json, Grape::Formatter::Rabl
        content_type :json, 'application/json; charset=UTF-8'

        rescue_from Faraday::Error::ResourceNotFound do |e|
          rack_response(MultiJson.dump(error: '404 Resource Not Found'), 404)
        end

        helpers do
          def logger
            $logger
          end

          def current_user
            @current_user ||= User.authorize!(env)
          end

          def authenticate!
            error!('401 Unauthorized', 401) unless current_user
          end
        end

        before do
          authenticate!
        end
      end

    end
  end
end
