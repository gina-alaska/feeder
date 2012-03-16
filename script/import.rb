require "thor"

class FileNotSupported < Exception; end

class Import < Thor
  desc "image SLUG FOLDER", "import radar image into feeds"
  def image(slug, item)
    if File.directory? item
      files = Dir.glob(File.join(item, '**/*')) 
    elsif File.exists? item
      files = [item]
    else
      raise "Unable to find #{folder}"
    end
    
    feed = Feed.where(:slug => slug).first
    raise "Unable to find feed for #{slug}" if feed.nil?
    
    files.each do |filename|    
      next if filename[0] == ?.
      next if File.directory? filename

      file = File.basename(filename)
      puts "Importing #{file}"  
     
      begin
        entry_slug,title,category,year,month,day,hour,minute = breakdown(file)
      rescue FileNotSupported => e
        puts "Skipping #{e.message}"
        next
      end

      path_fragment = File.join('feeds', slug, year, month, day)
      path = Rails.root.join('public', path_fragment)
      
      attributes = {
        slug: entry_slug,
        title: title,
        file: "#{path_fragment}/#{file}",
        category: category,
        event_at: DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, 0),
        where: "POINT(-156.788333 71.2925)"
      }

      entry = feed.entries.where(slug: entry_slug).first
 
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
        category = "radar"
      when /^(\d{4})(\d{2})(\d{2})_day.gif/
        dummy, year, month, day = filename.match(/^(\d{4})(\d{2})(\d{2})_day.gif/).to_a
        title = "#{year}-#{month}-#{day}"
        category = "radar_animation"
      when /^ABCam_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2}).jpg$/
        dummy, year, month, day, hour, minute = filename.match(/^ABCam_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2}).jpg$/).to_a
        title = "#{year}-#{month}-#{day} #{hour}:#{minute}"
        category = "webcam"
      else
        raise FileNotSupported.new filename
      end
    
      slug = Entry.build_slug(title)
      [slug, title, category, year, month, day, hour, minute]
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
