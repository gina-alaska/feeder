class EntriesController < ApplicationController
  respond_to :html, :georss, :xml, :json, :js
  
  before_filter :fetch_feed, :only => [:index, :show, :image, :preview, :chooser, :search]
  
  def show
    if params[:size] 
      cookies[:preview_size] = params[:size]
    end
    cookies[:preview_size] ||= 'desktop'
    
    if params[:id] == 'current'
      @entry = @feed.current_entries.first
    else
      @entry = @feed.entries.latest.where(slug: params[:id]).first    
    end
    search
    # if @entry.nil?
    #   render 'public/404', :status => :not_found
    # else
    #   respond_with @entry
    # end
  end
  
  def like
    @entry = Entry.where(slug: params[:id]).first 
    @like = @entry.likes.where(user_id: current_user).first
    
    if @like.nil?
      @entry.likes.create(user: current_user)
    else
      @like.destroy
    end
    
    respond_to do |format|
      format.js
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
  
  def search
    super
    
    @width = params[:width] || 1440
    @height = params[:height] || 900
    
    respond_to do |format|
      format.html {
        if params[:output] == 'bgimage'
          render 'detect_size'
        end
      }
      format.js {
        if params[:output] == 'bgimage'
          render 'bgimage'
        end        
      }
      format.json {
        results = @entries.results.collect do |e| 
          e.as_json(:only => [:id, :title, :slug, :event_at, :created_at, :updated_at]).merge({
            previews: {
              small: File.join('http://', request.host, e.preview.try(:thumb, '500x500').try(:url)),
              medium: File.join('http://', request.host, e.preview.try(:thumb, '1000x1000').try(:url)),
              large: File.join('http://', request.host, e.preview.try(:thumb, '2000x2000').try(:url))              
            },
            moreinfo: '',
            thumbnail: File.join('http://', request.host, e.preview.try(:thumb, '250x250').try(:url)),
            image: File.join('http://', request.host, e.preview.try(:url))
          })
        end
        respond_with(results)
      }
      format.xml
      format.georss
    end
  end
  
  def index
    search
    
    # respond_to do |format|
    #   format.html
    #   format.georss
    #   format.json {
    #     results = @entries.results.collect do |e| 
    #       e.as_json(:only => [:id, :title, :slug, :updated_at]).merge({
    #         :thumbnail => File.join('http://', request.host, e.preview.try(:thumb, '250x250').try(:url)),
    #         :image => File.join('http://', request.host, e.preview.try(:url))
    #       })
    #     end
    #     respond_with(results)
    #   }
    # end
    # if params[:date]
    #   year, month = params[:date].split('-')
    #   date = DateTime.civil(year.to_i, month.to_i)
    #   @entries = @feed.entries.latest.where('event_at between ? and ?', date, date.end_of_month)
    # else
    #   @entries = @feed.entries.latest
    # end
    # @entries = @entries.page(params[:page]).per(12)
  end
  
  def chooser
    if params[:id] == 'current'
      @entry = @feed.current_entries.first
    else
      @entry = @feed.entries.latest.where(slug: params[:id]).first    
    end
    
    respond_with @entry 
  end
  
  protected
  
  def fetch_feed
    @feed = Feed.where(slug: params[:slug]).first if params[:slug]
  end
end
