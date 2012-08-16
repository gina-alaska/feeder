class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :set_layout

  private
  def set_layout
    logger.info '*********'
    logger.info request.headers['X-PJAX']
      
    if request.headers['X-PJAX']
      "pjax"
    else
      "application"
    end
  end  
end
