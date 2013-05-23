class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]
  
  def create
    unless @auth = Authorization.find_from_hash(auth_hash)
      @auth = Authorization.create_from_hash(auth_hash, current_user)
    end
    
    sign_in_user(@auth.user)
    
    flash[:success] = "Successfully logged in as #{current_user.name}"
    redirect_back_or_default(root_url)
  end
  
  def destroy
    reset_session
    flash[:success] = 'Signed out!'
    redirect_back_or_default(root_url)
  end
  
  def new
    redirect_to('/auth/google')
  end
  
  def failure
    flash[:error] = "Authentication error: #{params[:message].humanize}"
    redirect_to root_url
  end
  
  protected
  
  def auth_hash
    logger.info request.env['omniauth.auth']
    request.env['omniauth.auth']
  end
end
