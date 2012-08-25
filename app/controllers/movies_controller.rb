class MoviesController < ApplicationController
  before_filter :get_feed

  def index
  end
  
  def show
    duration = 1
    
    date = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i).beginning_of_day
    @movie = @feed.movies.where(:event_at => date.utc, :duration => duration.to_i).first

    if @movie.nil?
      #generate the movie
      @movie = @feed.movies.build(:event_at => date, :duration => duration.to_i)
      @movie.generate
      @movie.save!
    end
  end
  
  protected
  
  def get_feed
    @feed = Feed.where(slug: params[:slug]).first
  end
end
