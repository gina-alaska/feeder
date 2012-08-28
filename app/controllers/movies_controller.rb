class MoviesController < ApplicationController
  before_filter :get_feed

  def index
    @movies = {}
    @feed.active_animations.each do |duration|
      @movies[duration] = @feed.movies.where(status: 'available', duration: duration).order('event_at DESC').first
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
      format.mp4 {
        send_file(@movie.as_mp4)
      }
      format.webm {
        send_file(@movie.as_webm)
      }
      format.png {
        send_file(File.join(Rails.public_path, @movie.entries.first.file.thumb.url), :disposition => 'inline')
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
