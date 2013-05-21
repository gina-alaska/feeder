class EntriesController < ApplicationController
  respond_to :html, :georss, :xml
  
  before_filter :fetch_feed, :only => [:index, :show, :image, :preview]
  
  def show
    if params[:id] == 'current'
      @entry = @feed.current_entries.first
    else
      @entry = @feed.entries.latest.where(slug: params[:id]).first    
    end
    
    if @entry.nil?
      render 'public/404', :status => :not_found
    else
      respond_with @entry
    end
  end
  
  def image
    if params[:id] == 'current'
      @entry = @feed.current_entries.first
    else
      @entry = @feed.entries.latest.where(slug: params[:id]).first    
    end
    
    if @feed.status.to_sym == :offline && params[:id] == 'current'
      txt = "-draw 'text 0 0 \"The #{@feed.title}\nis offline\"'"
      send_data(@entry.preview.process(:convert, "-gravity center -fill white -stroke black -strokewidth 30 -pointsize 90 #{txt} -stroke none #{txt}").data, :type => @entry.preview.format, :disposition => 'inline')
    else
      send_file(@entry.image.path, :disposition => 'inline')
    end
  end
  
  def preview
    if params[:id] == 'current'
      @entry = @feed.entries.current.first
    else
      @entry = @feed.entries.latest.where(slug: params[:id]).first    
    end
    
    respond_to do |format|
      format.jpg {
        redirect_to @entry.preview.jpg.url
      }
      format.png {
        redirect_to @entry.preview.png.url
      }
    end
  end
  
  def index
    if params[:date]
      year, month = params[:date].split('-')
      date = DateTime.civil(year.to_i, month.to_i)
      @entries = @feed.entries.latest.where('event_at between ? and ?', date, date.end_of_month)
    else
      @entries = @feed.entries.latest
    end
    @entries = @entries.page(params[:page]).per(12)
  end
  
  def search
    @search = params[:search] || {}
    
    if feed_ids = pull_feed_ids
      @entries = Entry.where(:feed_id => feed_ids).order('event_at DESC')
      @entries = @entries.page(params[:page]).per(12)
    end
    
    unless @search[:start].blank?
      @entries = @entries.where('event_at >= ?', Time.zone.parse(@search[:start]).beginning_of_day)
    end
    unless @search[:end].blank?
      @entries = @entries.where('event_at <= ?', Time.zone.parse(@search[:end]).end_of_day)
    end
    
    if @entries.nil? or @entries.count == 0
      render 'shared/no_results'
    end
  end
  
  protected
  
  def pull_feed_ids
    return false unless params.include?(:search) and params[:search].include?(:feeds)
    
    feeds = params[:search][:feeds]
    feeds.inject([]) { |c,i| c << i[0].to_i if i[1].to_i == 1 }
  end
  
  def fetch_feed
    @feed = Feed.where(slug: params[:slug]).first
  end
end
