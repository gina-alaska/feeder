class RssController < ApplicationController
  respond_to :xml
  
  def show
    @feed = Feed.where(:slug => params[:slug]).first
    if params[:id].nil?
      @entries = @feed.entries.includes(:feed).order('event_at DESC').page(params[:page])
    else
      @entries = @feed.entries.includes(:feed)..where(:title => params[:id]).order('event_at DESC').page(params[:page])      
    end
    respond_with @feed, @entries
  end
end
