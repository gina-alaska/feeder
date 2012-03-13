class FeedsController < ApplicationController
  respond_to :html
  
  def index
  end
  
  def show
    @feed = Feed.where(:slug => params[:slug]).first
    if params[:id].nil?
      @entries = @feed.entries.includes(:feed)
      @entries = @entries.order('event_at DESC').page(params[:page]).per(12)
    elsif params[:id] == 'current'
      @entries = @feed.entries.order('event_at DESC').limit(1)
    else
      @entries = @feed.entries.includes(:feed).where(:slug => params[:id])
      @entries = @entries.order('event_at DESC').page(params[:page]).per(12)
    end


    respond_with @feed, @entries
  end
end
