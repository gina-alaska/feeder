class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :set_layout
  
  protected
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end

  helper_method :current_user, :signed_in?

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
  end
  

  def redirect_back_or_default(url)
    if session[:redirect_back_location].present?
      l = session.delete(:redirect_back_location)
      redirect_to l
    else
      redirect_to url
    end
  end
  
  def require_admin_auth
    if current_user.nil?
      session[:redirect_back_location] = request.url
      redirect_to signin_path
    elsif not current_user.admin?
      flash[:error] = 'You do not have permission to access this page'
      redirect_to root_url
    end
  end

  private
  def set_layout
    if request.headers['X-PJAX']
      "pjax"
    else
      "application"
    end
  end  
end
