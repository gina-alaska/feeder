class AtomsController < ApplicationController
  skip_authorization_check
  
  def show
    @feed = Feed.where(:slug => params[:id]).first
    @entries = @feed.entries.includes(:feed).order('event_at DESC').page(params[:page])

    respond_to do |format|
      format.xml
    end
  end
end
