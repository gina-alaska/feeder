class EntriesController < ApplicationController
  skip_authorization_check

  before_filter :fetch_feed, :only => [:index, :show, :image, :preview, :embed]

  def show
    if params[:id] == 'current'
      @entry = @feed.current_entries.first
    else
      @entry = @feed.entries.latest.where(slug: params[:id]).first
    end
    search

    if @entry.nil?
      render file: Rails.root.join("public/404.html"), layout: false, :status => :not_found
    else
      respond_to do |format|
        format.html
        format.georss
        format.xml
        format.json
      end
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

  def embed
    if params[:id] == 'current'
      @entry = @feed.entries.current.first
      @url = current_image_path(@feed, 'current', format: :png)
    else
      @entry = @feed.entries.latest.where(slug: params[:id]).first
      @url = current_image_path(@feed, @entry, format: :png)
    end

    respond_to :html, :js
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
            thumbnail: File.join('http://', request.host, e.preview.try(:thumb, '250x250').try(:url)),
            image: File.join('http://', request.host, e.preview.try(:url)),
            source: File.join('http://', request.host, e.image.try(:remote_url)),
            source_size: e.image.size
          })
        end
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

  protected

  def fetch_feed
    @feed = Feed.where(slug: params[:slug]).first
  end
end
