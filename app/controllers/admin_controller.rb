class AdminController < ApplicationController
  before_action :require_admin!

  private
  def require_admin!
    raise CanCan::AccessDenied unless signed_in? && current_user.site_admin?
  end
end
