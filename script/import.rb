require "thor"

class Import < Thor
  desc "radar SLUG FOLDER", "import radar image into feeds"
  def radar(slug, folder)
    raise "Unable to find #{folder}" unless File.exists? folder
    
    feed = Feed.where(:slug => slug).first
    
    Dir.glob(File.join(folder, '*.png')).each do |filename|    
      file = File.basename(filename)
      puts "Importing #{file}"  
      
      match = file.match(/^SIR_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2}).png$/).to_a
    
      raise "Invalid filename expected SIR_YYYYMMDD_HHMM.png" if match.nil?
    
      dummy = match.shift
      year,month,day,hour,minute = match

      path_fragment = File.join('feeds', slug, year, month, day)
      path = Rails.root.join('public', path_fragment)
      FileUtils.mkdir_p(path)
      FileUtils.cp(filename, path)
    
      feeds_url = "http://feeder.dev"
      entry = feed.entries.where(title: "#{year}-#{month}-#{day} #{hour}:#{minute}").count
      puts "found #{entry} items"
      
      feed.entries.create!(
        title: "#{year}-#{month}-#{day} #{hour}:#{minute}",
        content: "<img src=\"#{feeds_url}/#{path_fragment}/#{file}\" alt=\"#{file}\" />",
        event_at: DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, 0),
        where: "POINT(-156.673 71.328)"
      ) if entry == 0        
    end
    feed.touch
  end
end

Import.start