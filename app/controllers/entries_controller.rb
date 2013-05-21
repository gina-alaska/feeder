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
    feed_ids = pull_ids(search_params, :feeds) || []
    sensor_ids = pull_ids(search_params, :sensors)
    unless sensor_ids
      sensor_ids = Sensor.where(selected_by_default: true).pluck(:id)
    end
    page = params[:page] || 1
    @search = search_params
    
    @entries = Entry.search do
      with(:feed_id, feed_ids) unless feed_ids.empty?
      with(:sensor_id, sensor_ids) unless sensor_ids.empty?
      with(:event_at).greater_than(Time.zone.parse(search_params[:start]).beginning_of_day) unless search_params[:start].blank?
      with(:event_at).less_than(Time.zone.parse(search_params[:end]).end_of_day) unless search_params[:end].blank?
      
      facet :sensor_id 
      facet :feed_id
      
      order_by(:event_at, :desc)
      paginate :page => page, :per_page => 15
    end
    
    @facets = {}
    %w{ feed_id sensor_id }.each do |name|
      @entries.facet(name.to_sym).rows.each do |f|
        @facets[name.to_sym] ||= {}
        @facets[name.to_sym][f.value] = f.count      
      end
    end
    
    # unless feed_ids.empty?
    #   unless sensor_ids.empty?
    #     feed_ids = Feed.where(id: feed_ids, sensor_id: sensor_ids).pluck(:id)
    #   end
    #   @entries = Entry.where(:feed_id => feed_ids).order('event_at DESC')
    # end
    # 
    # unless @search[:start].blank?
    #   @entries = @entries.where('event_at >= ?', Time.zone.parse(@search[:start]).beginning_of_day)
    # end
    # unless @search[:end].blank?
    #   @entries = @entries.where('event_at <= ?', Time.zone.parse(@search[:end]).end_of_day)
    # end
    
    # if @entries.nil? or @entries.count == 0
    #   @entries = Entry.order('event_at DESC')
    # end
    
    # @entries = @entries.page(params[:page]).per(12)
  end
  
  protected
  
  def search_params
    @search_params ||= params[:search] || {}
  end
  helper_method :search_params
  
  def pull_ids(search, field)
    return false unless search.include?(field)
    
    items = search[field]
    items.inject([]) { |c,i| c << i[0].to_i if i[1].to_i == 1 }
  end
  
  def fetch_feed
    @feed = Feed.where(slug: params[:slug]).first
  end
end
