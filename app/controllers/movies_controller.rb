class MoviesController < ApplicationController
  before_filter :get_feed

  def index
    search
    render 'search'
  end
  
  def search
    @feeds = Feed.animated
    @sensors = Sensor.where(id: @feeds.pluck(:sensor_id))
    @search_path = search_movies_path
    @movie_view = true
    
    feed_ids = pull_ids(:feeds) || @feeds.pluck(:id)
    logger.info selected_sensor_ids
    
    if !selected_sensor_ids or selected_sensor_ids.empty?
      @selected_sensor_ids = @sensors.pluck(:id)
    end
    if !selected_feed_ids or selected_feed_ids.empty?
      @selected_feed_ids = @feeds.pluck(:id)
    end
    
    page = params[:page] || 1
    
    @entries = Movie.search do
      with(:feed_id, selected_feed_ids) unless selected_sensor_ids.empty?
      with(:sensor_id, selected_sensor_ids) unless selected_sensor_ids.empty?
      with(:event_at).greater_than(Time.zone.parse(search_params[:start]).beginning_of_day) unless search_params[:start].blank?
      with(:event_at).less_than(Time.zone.parse(search_params[:end]).end_of_day) unless search_params[:end].blank?
      
      facet :sensor_id 
      facet :feed_id
      
      order_by :event_at, :desc
      paginate :page => page, :per_page => 15
    end
    @facets = {}
    %w{ feed_id sensor_id }.each do |name|
      @entries.facet(name.to_sym).rows.each do |f|
        @facets[name.to_sym] ||= {}
        @facets[name.to_sym][f.value] = f.count      
      end
    end
  end
  
  def show
    if params[:date]
      duration = params[:duration] || 1
      date = DateTime.parse(params[:date]).beginning_of_day.to_date
      @movie = @feed.movies.where(:event_at => date, :duration => duration.to_i).first
    elsif params[:id]
      if (params[:id] =~ /^current/).nil?
        @movie = @feed.movies.find(params[:id])
      else
        duration = params[:id].split('-')[1].to_i
        @movie = @feed.movies.where(:status => 'available', duration: duration).order('event_at DESC').first
      end
    end
    
    if @movie.nil?
      #generate the movie
      @movie = @feed.movies.build(:event_at => date, :duration => duration.to_i, :title => "#{duration} day animation")
      @movie.feed = @feed
      
      if @movie.entries.count > 0 && @movie.valid?
        @movie.save
        @movie.async_generate        
      end
    end
    
    search
    
    respond_to do |format|
      format.html {
        render :layout => false if request.xhr?
      }
      format.mp4 {
        send_file(@movie.as_mp4)
      }
      format.webm {
        send_file(@movie.as_webm)
      }
      format.jpg {
        redirect_to @movie.entries.first.preview.jpg.url
      }
      format.png {
        redirect_to @movie.entries.first.preview.png.url
      }
    end
  end
  
  protected
  
  def get_feed
    if params[:slug]
      @feed = Feed.where(slug: params[:slug]).first
    elsif params[:feed_id]
      @feed = Feed.where(slug: params[:feed_id]).first
    end
  end
end
