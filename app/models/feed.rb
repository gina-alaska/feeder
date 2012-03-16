class Feed < ActiveRecord::Base
  include GeoRuby::SimpleFeatures

  has_many :entries
  
  def to_param
    self.slug
  end
  
  def georss_location
    Geometry.from_ewkt(self.where).as_georss unless self.where.empty?
  end
  
  class << self
    def import(slug, item)
      if File.directory? item
        files = Dir.glob(File.join(item, '**/*')) 
      elsif File.exists? item
        files = [item]
      else
        raise "Unable to find #{item}"
      end

      feed = where(:slug => slug).first
      raise "Unable to find feed for #{slug}" if feed.nil?

      files.each do |filename|    
        next if filename[0] == ?.
        next if File.directory? filename

        file = File.basename(filename)
        puts "Importing #{file}"  

        entry_slug,title,category,year,month,day,hour,minute = breakdown(file)
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
        raise "Unable to breakdown filename, #{filename}"
      end

      slug = Entry.build_slug(title)
      [slug, title, category, year, month, day, hour, minute]
    end    
  end
end
