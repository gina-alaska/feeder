class FeedsController < ApplicationController
  respond_to :html
  
  def index
    @feeds = Feed #.includes(:current_entries)
    if params[:q]
      @feeds = @feeds.where('title like ?', "%#{params[:q]}%")
    end
    @feeds = @feeds.order('slug ASC')
    
    @keywords = %w{ MODIS SNPP Barrow }

    @total = 0
    @counts = {}
    @all_feeds = Feed.all
    Feed.all.each do |f|
      next if f.entries.current.empty?
      @keywords.each do |kw|
        @counts[kw] ||= 0
        if f.title =~ /#{kw}/
          @counts[kw] += 1
          @total += 1
        end
      end
    end
  end
  
  def show
    if params[:slug]
      @feed = Feed.where(:slug => params[:slug]).order('slug ASC').first
    elsif params[:id]
      @feed = Feed.where(:slug => params[:id]).order('slug ASC').first
    end
    
    if @feed.nil?
      render 'public/404.html', status: :not_found
      return
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
    if params[:id] == 'current'
      @entry = @feed.entries.current.first
    elsif params[:id]
      @entry = @feed.entries.where(slug: params[:id]).first
    end
    if @feed.status.to_sym == :offline
      txt = "-draw 'text 0 0 \"The #{@feed.title}\nis offline\"'"
      send_data(@entry.preview.process(:convert, "-gravity center -fill white -stroke black -strokewidth 30 -pointsize 90 #{txt} -stroke none #{txt}").data, :type => @entry.preview.format, :disposition => 'inline')
    else
      send_file(@entry.image.path, :disposition => 'inline')
    end
  end
end
