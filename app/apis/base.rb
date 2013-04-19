require 'grape/middleware/api_logger'

module SublimeVideo
  module APIs
    module Base
      extend ActiveSupport::Concern

      included do
        use Grape::Middleware::ApiLogger

        use Grape::Middleware::Auth::OAuth2, token_class: 'Oauth2Token',
                                             parameter: 'access_token',
                                             realm: 'SublimeVideo Protected Resources'

        content_type :json, 'application/json; charset=UTF-8'
        format :json
        formatter :json, Grape::Formatter::Rabl
        use(Rack::Config) { |env| env['api.tilt.root'] = File.expand_path('../views', __dir__) }
        rescue_from ActiveRecord::RecordNotFound do |e|
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
