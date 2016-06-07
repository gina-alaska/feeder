class RssController < ApplicationController
  skip_authorization_check

  def show
    @feed = Feed.where(:slug => params[:slug]).first
    if params[:id].nil?
      @entries = @feed.entries.includes(:feed).order('event_at DESC')
      @entries = @entries.limit(25)
    elsif params[:id] == 'current'
      @entries = @feed.entries.order('event_at DESC').limit(1)
    else
      @entries = @feed.entries.includes(:feed).where(:slug => params[:id]).order('event_at DESC')
    end

    respond_to do |format|
      format.xml
    end
  end
end
