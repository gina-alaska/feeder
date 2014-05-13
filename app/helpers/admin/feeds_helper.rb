module Admin::FeedsHelper
  def web_hook_label(web_hook)
    web_hook.active ? "success" : ""
  end
end
