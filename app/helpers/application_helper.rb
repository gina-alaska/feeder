module ApplicationHelper
  def cw_image_url(img)
    File.join(root_url, img.url) unless img.url.nil?
  end
end
