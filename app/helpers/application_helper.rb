module ApplicationHelper
  def feed_cdn_url(path= nil)
    if Feeder::Application.config.feed_cdn_urls.nil?
      url = root_url
    else
      url = Feeder::Application.config.feed_cdn_urls[rand(Feeder::Application.config.feed_cdn_urls.count)]
    end
    
    unless path.nil?
      url = File.join(url, path)
    end
      
    url
  end
  
  def cw_image_url(img)
    feed_cdn_url(img.url) unless img.url.nil?
  end
  
  def feed_select_options
    feeds = Feed.order('slug ASC').inject([]) do |c,f|
      c << [f.title, slug_url(f)] if f.entries.count > 0
      c
    end
    # selected = @feed.nil? ? nil : slug_url(@feed)
    options_for_select(feeds)
  end
end
