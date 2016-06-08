class Admin::FeedsController < AdminController
  before_filter :fetch_feed, :only => [:edit, :update, :destroy]

  def index
    @feeds = Feed.all
  end

  def edit
    @feed.web_hooks.build
  end

  def update
    if @feed.update_attributes(feed_params)
      respond_to do |format|
        format.html {
          flash[:success] = "#{@feed.title} sucessfully updated"
          redirect_to admin_feeds_path
        }
      end
    else
      respond_to do |format|
        format.html {
          render :action => :edit
        }
      end
    end
  end

  def new
    @feed = Feed.new
    @feed.web_hooks.build
  end

  def create
    @feed = Feed.new(feed_params)
    if @feed.save!
      respond_to do |format|
        format.html {
          flash[:success] = "#{@feed.title} sucessfully created"
          redirect_to admin_feeds_path
        }
      end
    else
      respond_to do |format|
        format.html {
          render :action => :edit
        }
      end
    end
  end

  def destroy
    if @feed.destroy
      respond_to do |format|
        format.html {
          flash[:success] = "#{@feed.title} feed deleted"
          redirect_to admin_feeds_path
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Unable to delete feed"
          redirect_to admin_feeds_path
        }
      end
    end
  end

  protected

  def fetch_feed
    @feed = Feed.where(slug: params[:id]).first
  end

  def feed_params
    params.require(:feed).permit(:title, :slug, :ingest_slug, :sensor_id, :status,
      :description, web_hooks: [:url, :active, :_destroy])
  end

end
