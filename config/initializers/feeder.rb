if Rails.env == 'production'
  Feeder::Application.config.feed_cdn_urls = ['http://feeder.gina.alaska.edu']
else
  Feeder::Application.config.feed_cdn_urls = nil
end  