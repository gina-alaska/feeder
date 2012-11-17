class AdminController < ApplicationController
  layout :set_layout
  
  protected
  
  def set_layout
    if request.headers['X-PJAX']
      "pjax"
    else
      "admin"
    end
  end
end
