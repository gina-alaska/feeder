class EntriesController < ApplicationController
  respond_to :html, :georss, :xml
  def show
    @feed = Feed.where(:slug => params[:feed_id]).first
    @entry = @feed.entries.where(:title => params[:id]).first
    
    respond_with @entry
  end
end
