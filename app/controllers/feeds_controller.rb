class FeedsController < ApplicationController
  skip_authorization_check

  before_filter :fetch_keywords, :only => [:index, :search]

  def index
    @feeds = Feed #.includes(:current_entries)
    if params[:q]
      @feeds = @feeds.where('title like ?', "%#{params[:q]}%")
    end
    @feeds = @feeds.order('status DESC, title ASC')

    respond_to do |format|
      format.html
      format.json {
        @feeds = @feeds.collect { |f| f.as_json.merge(:entries => slug_url(f, :format => :json), :moreinfo => slug_url(f) ) }
      }
    end
  end

  def search
    @feeds = Feed #.includes(:current_entries)
    if params[:q]
      @feeds = @feeds.where('title like ?', "%#{params[:q]}%")
    end
    @feeds = @feeds.order('status DESC, title ASC')
  end

  def carousel
    @feed = Feed.where(:slug => params[:slug]).order('slug ASC').first
    @entries = @feed.entries.latest.includes(:feed)
    @entries = @entries.order('event_at ASC').page(params[:page]).per(12)

    respond_to do |format|
      format.html
      format.json
    end
  end

  protected

  def fetch_keywords
    @keywords = %w{ MODIS SNPP Barrow }
  end
end
