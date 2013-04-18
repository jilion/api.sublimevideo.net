class Site
  include SublimeVideoPrivateApi::Model

  uses_private_api :my # SV app subdomain where model is located.
  collection_path '/private_api/users/:user_id/sites'
end
