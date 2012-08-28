class FeedsController < ApplicationController
  respond_to :html
  
  def index
    @feeds = Feed.order('slug ASC')
  end
  
  def show
    if params[:slug]
      @feed = Feed.where(:slug => params[:slug]).order('slug ASC').first
    elsif params[:id]
      @feed = Feed.where(:slug => params[:id]).order('slug ASC').first
    end
    
    
    if params[:date]
      year, month = params[:date].split('-')
      date = Date.civil(year.to_i, month.to_i)
      @entries = @feed.entries.includes(:feed).where('event_at between ? and ?', date, date.end_of_month)
      @entries = @entries.order('event_at DESC').page(params[:page]).per(12)
    elsif params[:id].nil?
      @entries = @feed.entries.includes(:feed)
      @entries = @entries.order('event_at DESC').page(params[:page]).per(12)
    elsif params[:id] == 'current'
      @entries = @feed.entries.current
    else
      @entries = @feed.entries.includes(:feed).where(:slug => params[:id])
      @entries = @entries.order('event_at DESC').page(params[:page]).per(12)
    end

    if @entries.count == 1
      @prev_entry = @feed.entries.where('event_at < ?', @entries.first.event_at).order('event_at DESC').first      
      @next_entry = @feed.entries.where('event_at > ?', @entries.first.event_at).order('event_at ASC').first      
    end

    respond_with @feed, @entries, :layout => (params[:rss] ? 'rss' : true)
  end
  
  def carousel
    @feed = Feed.where(:slug => params[:slug]).order('slug ASC').first
    @entries = @feed.entries.includes(:feed)
    @entries = @entries.order('event_at DESC').page(params[:page]).per(12)
    
    respond_with @feed, @entries
  end
  
  def image
    @feed = Feed.where(:slug => params[:slug]).order('slug ASC').first
    send_file(@feed.entries.last.file.current_path, :disposition => 'inline')
  end
end
