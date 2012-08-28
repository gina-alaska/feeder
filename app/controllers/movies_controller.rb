class MoviesController < ApplicationController
  before_filter :get_feed

  def index
    @movies = {}
    @feed.active_animations.each do |duration|
      @movies[duration] = Movie.where(status: 'available', duration: duration).order('event_at ASC').first
    end
  end
  
  def show
    duration = params[:duration] || 1
    date = DateTime.parse(params[:date]).beginning_of_day.to_date
    @movie = @feed.movies.where(:event_at => date, :duration => duration.to_i).first

    if @movie.nil?
      #generate the movie
      @movie = Movie.new(:event_at => date, :duration => duration.to_i, :title => "#{duration} day animation")
      @movie.feed = @feed
      
      if @movie.entries.count > 0 && @movie.valid?
        @movie.save
        @movie.async_generate        
      end
    end
    
    respond_to do |format|
      format.html {
        render :layout => false if request.xhr?
      }
    end
  end
  
  protected
  
  def get_feed
    @feed = Feed.where(slug: params[:slug]).first
  end
end
