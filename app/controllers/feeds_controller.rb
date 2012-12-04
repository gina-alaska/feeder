class FeedsController < ApplicationController
  respond_to :html
  
  def index
    @feeds = Feed #.includes(:current_entries)
    if params[:q]
      @feeds = @feeds.where('title like ?', "%#{params[:q]}%")
    end
    @feeds = @feeds.order('slug ASC')
    
    @keywords = %w{ MODIS SNPP Barrow }
  end
  
  def carousel
    @feed = Feed.where(:slug => params[:slug]).order('slug ASC').first
    @entries = @feed.entries.includes(:feed)
    @entries = @entries.order('event_at DESC').page(params[:page]).per(12)
    
    respond_with @feed, @entries
  end
end
