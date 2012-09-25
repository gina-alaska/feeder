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
    img.respond_to?(:url) ? feed_cdn_url(img.url) : feed_cdn_url(img)
  end
  
  def feed_select_options
    feeds = Feed.order('slug ASC').inject([]) do |c,f|
      c << [f.title, slug_url(f)] if f.entries.count > 0
      c
    end
    # selected = @feed.nil? ? nil : slug_url(@feed)
    options_for_select(feeds)
  end
  
  def current_date_range(entries)
    if (entries.first.event_at - entries.last.event_at) >= 1.day
      "#{entries.first.event_at.strftime('%Y/%m/%d')} - #{entries.last.event_at.strftime('%Y/%m/%d')}"
    else
      entries.first.event_at.strftime('%Y/%m/%d')
    end
  end
end
