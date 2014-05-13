class WebHooksController < AdminController
  before_filter :set_region, only: [:edit, :update, :destroy]
  def new
    @web_hook = WebHook.new
  end

  def create
    @web_hook = WebHook.new(web_hook_params)
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def web_hook_params
  end

  def set_web_hook
    @web_hook = WebHook.find(params[:id])
  end
end
