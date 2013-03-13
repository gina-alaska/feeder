Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'   
  provider :open_id, :name => 'gina', :identifier => 'https://id.gina.alaska.edu', :store => OpenID::Store::Filesystem.new('/tmp')
  provider :open_id, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id', :store => OpenID::Store::Filesystem.new('/tmp')
end