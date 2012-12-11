class Admin::FeedsController < AdminController
  before_filter :fetch_feed, :only => [:edit, :update, :destroy]
  
  respond_to :html
  
  def index
    @feeds = Feed.includes(:entries).all
    
    respond_with @feeds
  end
  
  def edit
    respond_with @feed
  end
  
  def update
    if @feed.update_attributes(params[:feed])
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
  end
  
  def create
    @feed = Feed.new(params[:feed])
    if @feed.save
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
end
