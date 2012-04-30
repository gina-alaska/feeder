class Feed < ActiveRecord::Base
  include GeoRuby::SimpleFeatures

  has_many :entries do
    def current
      order('event_at DESC').limit(1)
    end
  end
  
  def to_param
    self.slug
  end
  
  def georss_location
    Geometry.from_ewkt(self.where).as_georss unless self.where.empty?
  end
  
  class << self
    def import(slug, item, type = 'barrow')
      feed = where(:slug => slug).first
      raise "Unable to find feed for #{slug}" if feed.nil?

      case type.to_sym 
      when :barrow
        barrow(feed, item)
      when :npp
        npp(feed, item)
      end
    end

    def npp(feed, item)
      if File.directory? item
        files = Dir.glob(File.join(item, '**/*.tif'))
      elsif File.exists? item
        files = [item]
      else
        raise "Unable to find #{item}"
      end

      files.each do |filename|
        next if filename[0] == ?.
        next if File.directory? filename

        file = File.basename(filename, '.tif')
        tif = file + '.tif'
        png = file + '.png'
        puts "Importing #{file}"  

        metainfo = breakdown(tif)
        path_fragment = File.join('feeds', feed.slug, metainfo[:year].to_s, metainfo[:month].to_s, metainfo[:day].to_s)
        path = Rails.root.join('public', path_fragment)
        
        attributes = {
          slug: metainfo[:entry_slug],
          title: metainfo[:title],
          file: "#{path_fragment}/#{png}",
          category: metainfo[:category],
          event_at: DateTime.new(metainfo[:year].to_i, metainfo[:month].to_i, metainfo[:day].to_i, metainfo[:hour].to_i, metainfo[:minute].to_i, 0),
          where: metainfo[:where]
        }

        entry = feed.entries.where(slug: metainfo[:entry_slug]).first
        
        from_file = File.join(File.dirname(filename), File.basename(png))
        to_file = File.join(File.dirname(path), File.basename(png))
        unless File.exists?(to_file)
          FileUtils.mkdir_p(path)
          FileUtils.cp(from_file, path)
        end

        if entry.nil?
          feed.entries.create!(attributes)
        else
          entry.update_attributes(attributes)
        end

        feed.touch 
      end
    end

    def barrow(feed, item)
      if File.directory? item
        files = Dir.glob(File.join(item, '**/*')) 
      elsif File.exists? item
        files = [item]
      else
        raise "Unable to find #{item}"
      end

      files.each do |filename|    
        next if filename[0] == ?.
        next if File.directory? filename

        file = File.basename(filename)
        puts "Importing #{file}"  

        metainfo = breakdown(file)
        path_fragment = File.join('feeds', feed.slug, metainfo[:year], metainfo[:month], metainfo[:day])
        path = Rails.root.join('public', path_fragment)

        attributes = {
          slug: metainfo[:entry_slug],
          title: metainfo[:title],
          file: "#{path_fragment}/#{file}",
          category: metainfo[:category],
          event_at: DateTime.new(metainfo[:year].to_i, metainfo[:month].to_i, metainfo[:day].to_i, metainfo[:hour].to_i, metainfo[:minute].to_i, 0),
          where: metainfo[:where] 
        }

        entry = feed.entries.where(slug: metainfo[:entry_slug]).first

        unless File.exists?(File.join(path, File.basename(filename)))
          FileUtils.mkdir_p(path)
          FileUtils.cp(filename, path)
        end

        if entry.nil?
          feed.entries.create!(attributes)
        else
          entry.update_attributes(attributes)
        end

        feed.touch
      end
    end

    def breakdown(filename)
      case filename
      when /^npp\.(\d{2})(\d{3}).(\d{2})(\d{2})_truecolor_station_mask_ortho_5k\.tif$/
        dummy, year, yday, hour, minute = filename.match(/^npp\.(\d{2})(\d{3}).(\d{2})(\d{2})_truecolor_station_mask_ortho_5k\.tif$/).to_a
        date = DateTime.strptime("#{year}-#{yday}", "%y-%j")
        day = date.day
        month = date.month
        year = date.year
        title = "#{year}-#{month}-#{day} #{hour}:#{minute}"
        category = "webcam"
        where = "POINT(-147.723056 64.843611)"
      when /^SIR_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2}).png$/
        dummy, year, month, day, hour, minute = filename.match(/^SIR_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2}).png$/).to_a
        title = "#{year}-#{month}-#{day} #{hour}:#{minute}"
        category = "radar"
        where = "POINT(-156.788333 71.2925)"
      when /^(\d{4})(\d{2})(\d{2})_day.gif/
        dummy, year, month, day = filename.match(/^(\d{4})(\d{2})(\d{2})_day.gif/).to_a
        title = "#{year}-#{month}-#{day}"
        category = "radar_animation"
        where = "POINT(-156.788333 71.2925)"
      when /^ABCam_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2}).jpg$/
        dummy, year, month, day, hour, minute = filename.match(/^ABCam_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2}).jpg$/).to_a
        title = "#{year}-#{month}-#{day} #{hour}:#{minute}"
        category = "webcam"
        where = "POINT(-156.788333 71.2925)"
      else
        raise "Unable to breakdown filename, #{filename}"
      end

      slug = Entry.build_slug(title)

      { 
        entry_slug: slug, 
        title: title, 
        category: category, 
        year: year, 
        month: month, 
        day: day, 
        hour: hour, 
        minute: minute, 
        where: where
      }
    end    
  end
end
