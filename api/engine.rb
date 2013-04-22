module SublimeVideo
  module API

    class Engine < Grape::API
      require 'api/v1/site'
      mount SublimeVideo::API::V1::Site
    end

  end
end
