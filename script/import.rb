require "thor"

class Import < Thor
  desc "radar SLUG FOLDER", "import radar image into feeds"
  def radar(slug, item)
    if File.directory? item
      files = Dir.glob(File.join(item, '*.png')) 
    elsif File.exists? item
      files = [item]
    else
      raise "Unable to find #{folder}"
    end
    
    feed = Feed.where(:slug => slug).first
    raise "Unable to find feed for #{slug}" if feed.nil?
    
    files.each do |filename|    
      file = File.basename(filename)
      puts "Importing #{file}"  
      
      title, year,month,day,hour,minute = breakdown(file)

      path_fragment = File.join('feeds', slug, year, month, day)
      path = Rails.root.join('public', path_fragment)
      FileUtils.mkdir_p(path)
      FileUtils.cp(filename, path)
    
      feeds_url = "http://feeder.dev"
      entry = feed.entries.where(title: title).count
      puts "found #{entry} items"
      
      feed.entries.create!(
        title: title,
        content: "<img src=\"#{feeds_url}/#{path_fragment}/#{file}\" alt=\"#{file}\" />",
        event_at: DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, 0),
        where: "POINT(-156.673 71.328)"
      ) if entry == 0        
    end
    
    feed.touch
  end
  no_tasks do
    def breakdown(filename)
      case filename
      when /^SIR_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2}).png$/
        dummy, year, month, day, hour, minute = filename.match(/^SIR_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2}).png$/).to_a
        title = "#{year}-#{month}-#{day} #{hour}:#{minute}"
      when /^(\d{4})(\d{2})(\d{2})_day.gif/
        dummy, year, month, day = filename.match(/^(\d{4})(\d{2})(\d{2})_day.gif/).to_a
        title = "Animation for #{year}-#{month}-#{day}"
      else
        raise "Unable to breakdown filename, #{filename}"
      end
    
      [title, year, month, day, hour, minute]
    end
  end
end

Import.start