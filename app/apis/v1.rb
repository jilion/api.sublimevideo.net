module SublimeVideo
  module APIs
    module V1
      extend ActiveSupport::Concern

      included do
        version 'v1', using: :header, vendor: 'sublimevideo'

        before do
          header 'X-SublimeVideo-Media-Type', "sublimevideo-v1; format=#{env['api.format']}"
        end
      end

    end
  end
end
