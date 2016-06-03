class Admin::WebHooksController < AdminController
  before_filter :set_web_hook, only: [:edit, :update, :destroy]

  def index
  end

  def new
    @web_hook = WebHook.new
  end

  def create
    @web_hook = WebHook.new(web_hook_params)
    @feed = Feed.find_by(id: params[:feed_id])

    redirect_to admin_feed_web_hooks_path
  end

  def edit
  end

  def update
    redirect_to admin_feed_web_hook_path(@web_hook, @web_hook.feed)
  end

  def destroy
    redirect_to admin_feed_web_hooks_path
  end

  private
  def web_hook_params
  end

  def set_web_hook
    @web_hook = WebHook.find(params[:id])
  end
end
