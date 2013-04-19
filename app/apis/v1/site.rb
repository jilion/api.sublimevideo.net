require 'app/apis/base'
require 'app/apis/v1'

module SublimeVideo
  module APIs
    module V1

      class Site < Grape::API
        include SublimeVideo::APIs::Base
        include SublimeVideo::APIs::V1

        resource :sites do
          desc "Returns all current authenticated user's sites."
          get '/', rabl: 'v1/sites/index' do
            @sites = current_user.sites
          end

          desc 'Returns a site.'
          params do
            requires :token, type: String, desc: 'Site token'
          end
          get '/:token', rabl: 'v1/sites/show' do
            @site = current_user.site(params[:token])
          end
        end
      end

    end
  end
end