class Site
  include SublimeVideoPrivateApi::Model

  uses_private_api :my # SV app subdomain where model is located.
end
