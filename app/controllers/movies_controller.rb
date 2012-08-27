class MoviesController < ApplicationController
  before_filter :get_feed

  def index
  end
  
  def show
    duration = 1
    
    date = DateTime.parse(params[:date]).beginning_of_day
    @movie = @feed.movies.where(:event_at => date, :duration => duration.to_i).first

    if @movie.nil?
      #generate the movie
      @movie = @feed.movies.create(:event_at => date.to_date, :duration => duration.to_i, :title => "#{duration} day animation")
      @movie.async_generate
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
