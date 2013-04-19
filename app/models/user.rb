require 'app/models/site'

class User
  include SublimeVideoPrivateApi::Model

  uses_private_api :my # SV app subdomain where model is located.

  def sites
    Site.all(user_id: id, not_archived: true)
  end

  def site(token)
    Site.find(token, user_id: id, not_archived: true)
  end

  def self.authorize!(env)
    env['api.token'] && env['api.token'].user
  end
end
