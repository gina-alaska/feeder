namespace :feeds do
  namespace :radar do
    desc "Import barrow radar feeds"
    task :import, [:filename] => :environment do |t,args|
      feed = Feed.where(:slug => 'barrow_radar').first
    end
  end
end