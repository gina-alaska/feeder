class AdminController < ApplicationController
  before_filter :require_admin_auth
end
