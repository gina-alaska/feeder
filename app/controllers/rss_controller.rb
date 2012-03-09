class RssController < ApplicationController
  respond_to :xml
  
  def show
    @feed = Feed.where(:slug => params[:slug]).first
    if params[:id].nil?
      @entries = @feed.entries.includes(:feed).order('event_at ASC')
      @entries = @entries.limit(25).offset(@entries.count - 25)
    else
      @entries = @feed.entries.includes(:feed).where(:slug => params[:id]).order('event_at DESC')
    end
    respond_with @feed, @entries
  end
end
