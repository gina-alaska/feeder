class MoviesController < ApplicationController
  before_filter :get_feed

  def index
  end
  
  def show
    duration = 1
    
    date = DateTime.new(params[:year], params[:month], params[:day])
    
    @movie = @feed.movies.where(:at => date, :days => days)

    if @movie.nil?
      #generate the movie
      @movie = Movie.create(:at => date, :duration => duration)
      @movie.generate
    end
  end
  
  protected
  
  def get_feed
    @feed = Feed.where(slug: params[:slug]).first
  end
end
