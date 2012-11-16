class Admin::FeedsController < AdminController
  before_filter :require_admin_auth
  before_filter :fetch_feed, :only => [:edit, :update, :destroy]
  
  respond_to :html
  
  def index
    @feeds = Feed.all
    
    respond_with @feeds
  end
  
  def edit
    respond_with @feed
  end
  
  def new
    @feed = Feed.new
  end
  
  def destroy
    if @feed.destroy
      respond_to do |format|
        format.html { 
          flash[:success] = "Deleted feed #{@feed.title}"
          redirect_to admin_feeds_path
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Unable to delete feed #{@feed.title}"
          redirect_to admin_feeds_path
        }
      end
    end
  end
  
  protected
  
  def fetch_feed
    @feed = Feed.where(slug: params[:id]).first
  end
end
