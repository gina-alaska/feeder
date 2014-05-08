def ping(hook_id)
  p = PingEvent.create(web_hook_id: hook_id)
  status = p.notify.response.kind_of?(Net::HTTPSuccess)
  p.update_attribute(:response, status ? "success" : "failure")
  status
end

namespace :webhooks do
  desc "Ping all webhooks"
  task :ping => :environment do
    WebHook.where(active: true).all.each do |web_hook|
      puts "[#{ping(web_hook.id) ? '  UP  ' : ' DOWN '}] - #{web_hook.url}"
    end
  end

  task :add, [:feed,:url] => :environment do |t, args|
    feed = Feed.where(slug: args[:feed]).first
    if feed.nil?
      abort "Unable to find #{args[:feed]}"
    end

    w = WebHook.where(feed_id: feed.id, url: args[:url]).first_or_create

    status = ping(w.id)
    if !status
      w.update_attribute(:active, false)
      puts "Hook has been created, but did not respond to ping.. disabling"
    else
      puts "Hook has been created."
    end
  end

  task :enable, [:feed, :url] => :environment do |t, args|
    f = Feed.where(slug: args[:feed]).first
    w = WebHook.where(url: args[:url], feed: f.id).first

    if ping(w)
      w.update_attribute(:active, true)
      puts "Hook enabled"
    else
      puts "Hook did not respond to ping"
    end
  end
end
