namespace :dragonfly do
  desc 'Update all entries with the new dragonfly fields'
  task :update_entries => :environment do 
    Entry.order('created_at ASC').all.each do |e|
      next unless e.image.nil?
      
      puts "Converting #{e.title}"
      e.image = e.file
      e.save!
    end
  end
end