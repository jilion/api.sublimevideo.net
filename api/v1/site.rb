require 'api/base'
require 'api/v1/headers'

module SublimeVideo
  module API
    module V1

      class Site < Grape::API
        include SublimeVideo::API::Base
        include SublimeVideo::API::V1::Headers

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
