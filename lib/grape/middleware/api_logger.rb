module Grape
  module Middleware
    class ApiLogger < Grape::Middleware::Base
      def before
        file = env['api.endpoint'].source.source_location[0]
        line = env['api.endpoint'].source.source_location[1]
        $logger.debug "[api] #{file}:#{line}"
      end
    end
  end
end
