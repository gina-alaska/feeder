class FeedsController < ApplicationController
  respond_to :html, :georss, :xml
  
  def index
  end
  
  def show
    @feed = Feed.where(:slug => params[:id]).first
    @entries = @feed.entries.includes(:feed).paginate(:page => params[:page]).order('event_at DESC')
    respond_with @feed, @entries
  end
end
