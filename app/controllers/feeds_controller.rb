class FeedsController < ApplicationController
  respond_to :html
  
  def index
  end
  
  def show
    @feed = Feed.where(:slug => params[:slug]).first
    if params[:id].nil?
      @entries = @feed.entries.includes(:feed)
    else
      @entries = @feed.entries.includes(:feed).where(:slug => params[:id])
    end

    @entries = @entries.order('event_at DESC').page(params[:page]).per(12)

    respond_with @feed, @entries
  end
end
