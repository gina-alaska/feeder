namespace :webhooks do
  desc "Ping all webhooks"
  task :ping => :environment do
    WebHook.where(active: true).all.each do |web_hook|
      puts "Sending PING to #{web_hook.url}"
      p = PingEvent.create(web_hook_id: web_hook.id)
      response = p.notify

      p.update_attribute(:response, response.response.class.superclass == Net::HTTPSuccess)
    end
  end
end
