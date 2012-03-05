class FeedsController < ApplicationController
  respond_to :html, :georss, :xml
  
  def index
  end
  
  def show
    @feed = Feed.where(:slug => params[:id]).first
    respond_with @feed
  end
end
