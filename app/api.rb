require 'app/apis/v1/site'

module SublimeVideo
  class API < Grape::API
    mount SublimeVideo::APIs::V1::Site
  end
end
