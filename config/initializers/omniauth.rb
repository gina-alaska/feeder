Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'   
  provider :open_id, :name => 'gina', :identifier => 'https://id.gina.alaska.edu', :store => OpenID::Store::Filesystem.new('/tmp')
end