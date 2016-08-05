require 'httparty'

namespace :dev do
  desc "Import feeds and entires from production"
  task import: :environment do
    Rake::Task['dev:import:feeds'].invoke
    Rake::Task['dev:import:entries'].invoke
  end

  namespace :import do
    desc "Import feeds from production"
    task feeds: :environment do
      response = HTTParty.get("http://feeder.gina.alaska.edu/feeds.json")

      JSON.parse(response.body).each do |feed_info|
        next if Feed.find_by(slug: feed_info['slug'])

        puts "Creating #{feed_info['slug']}"

        feed = Feed.new({
          slug: feed_info['slug'],
          title: feed_info['title'],
          description: feed_info['description'],
          author: feed_info['author'],
          where: feed_info['where'],
          ingest_slug: feed_info['slug']
        })

        unless feed.save
          puts "Unable to save #{feed_info['slug']}:\n #{feed.errors.full_messages.join("\n")}"
        end
      end
    end

    desc "Import entires from production"
    task entries: :environment do
      Feed.find_each do |feed|
        response = HTTParty.get("http://feeder.gina.alaska.edu/#{feed.slug}.json")
        JSON.parse(response.body)[0..5].each do |entry|
          puts "Importing #{entry['source']}"
          feed.import(entry['source'], entry['event_at'])
        end
      end
    end
  end
end
