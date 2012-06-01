class FeedsController < ApplicationController
  respond_to :html
  
  def index
    @feeds = Feed.order('slug ASC')
  end
  
  def show
    @feed = Feed.where(:slug => params[:slug]).order('slug ASC').first
    if params[:id].nil?
      @entries = @feed.entries.includes(:feed)
      @entries = @entries.order('event_at DESC').page(params[:page]).per(12)
    elsif params[:id] == 'current'
      @entries = @feed.entries.current
    else
      @entries = @feed.entries.includes(:feed).where(:slug => params[:id])
      @entries = @entries.order('event_at DESC').page(params[:page]).per(12)
    end


    respond_with @feed, @entries
  end
end
