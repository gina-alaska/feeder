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
      feeds_url = "http://feeder.zoom.gina.alaska.edu"
      file = File.basename(filename)
      puts "Importing #{file}"  
      
      title, year,month,day,hour,minute = breakdown(file)
      path_fragment = File.join('feeds', slug, year, month, day)
      path = Rails.root.join('public', path_fragment)
      
      attributes = { 
        title: title,
        content: image_content("#{feeds_url}/#{path_fragment}/#{file}", title),
        event_at: DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, 0),
        where: "POINT(-156.788333 71.2925)"
      }

      entry = feed.entries.where(title: title).first
 
      if entry.nil?
        FileUtils.mkdir_p(path)
        FileUtils.cp(filename, path)
        feed.entries.create!(attributes)
      else
        entry.update_attributes(attributes)
      end

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

    def image_content(img, title, url = nil)
      <<-EOHTML
      <div class="puffin_feeder" style="text-align: center">
        <img src="#{img}" alt="#{title}" style="width:200px;" />
      </div>
      EOHTML
    end
  end
end

Import.start
