module Grape
  module Middleware
    class Logger < Grape::Middleware::Base

      def before
        route = env['api.endpoint'].routes[0]
        $logger.info "#{route}, params: #{route.route_params}, view: #{route.route_rabl}"
      end

    end
  end
end
