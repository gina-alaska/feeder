class AtomsController < ApplicationController
  respond_to :xml
  
  def show
    @feed = Feed.where(:slug => params[:id]).first
    @entries = @feed.entries.includes(:feed).order('event_at DESC').page(params[:page])
    respond_with @feed, @entries
  end
end
