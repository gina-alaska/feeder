class AdminController < ApplicationController
  before_action :authenticate_user!

  before_filter :require_admin_auth
end
