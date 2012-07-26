class Entry < ActiveRecord::Base
  include GeoRuby::SimpleFeatures
  
  # paginates_per 16

  belongs_to :feed

  mount_uploader :file, EntryFileUploader

  validates_presence_of :slug
  validates_presence_of :title
  validates_presence_of :event_at
  
  def to_param
    self.slug
  end
  
  def georss_location
    Geometry.from_ewkt(self.where).as_georss unless self.where.empty?
  end

  class << self
    def build_slug(text)
      text.downcase.gsub(/[\-\.:\s]/,'_')
    end
    
    def regexps
      {
        :npp_truecolor      => '^npp\.(\d{2})(\d{3})\.(\d{2})(\d{2})_M05_M04_M03_I01\.tif$',
        :npp_landcover      => '^npp\.(\d{2})(\d{3})\.(\d{2})(\d{2})_I03_I02_I01\.tif$',
        :barrow_radar_image => '^SIR_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})_masked\.png$',
        :barrow_radar_anim  => '^(\d{4})(\d{2})(\d{2})_(\d{1:2})day_animation\.mp4$',
        :barrow_webcam      => '^ABCam_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})\.jpg$'
      }
    end
    
    def fix_time_tz(time, zone)
      Time.parse(time.strftime("%Y/%m/%d %H:%M:%S #{zone}"))
    end

    def npp_regexp
      Regexp.new(regexps[:npp_truecolor])
    end
    
    def npp_landcover_regexp
      Regexp.new(regexps[:npp_landcover])
    end

    def barrow_radar_regexp
      Regexp.new(regexps[:barrow_radar_image])
    end

    def barrow_webcam_regexp
      Regexp.new(regexps[:barrow_webcam])
    end
    
    def barrow_animation_regexp
      Regexp.new(regexps[:barrow_radar_anim])
    end

    def metainfo(filename)
      case filename
      when barrow_animation_regexp
        dummy, year, month, day, anim_type = filename.match(barrow_animation_regexp).to_a
        title = sprintf('%4d-%02d-%02d %d day', year, month, day, anim_type)
        category = "movie"
        where = "POINT(-147.723056 64.843611)"
      when npp_landcover_regexp
        dummy, year, yday, hour, minute = filename.match(npp_landcover_regexp).to_a
        date = DateTime.strptime("#{year}-#{yday} #{hour}:#{minute}", "%y-%j %H:%M")
        day = date.day
        month = date.month
        year = date.year
        title = sprintf("%4d-%02d-%02d %02d:%02d (JD%3d)", year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, yday.to_i)
        # title += sprintf("\nnpp.%2d%03d.%02d%02d", year[2..3], yday, hour, minute)
        category = "npp"
        where = "POINT(-147.723056 64.843611)"
      when npp_regexp
        dummy, year, yday, hour, minute = filename.match(npp_regexp).to_a
        date = DateTime.strptime("#{year}-#{yday} #{hour}:#{minute}", "%y-%j %H:%M")
        day = date.day
        month = date.month
        year = date.year
        title = sprintf("%4d-%02d-%02d %02d:%02d (JD%3d)", year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, yday.to_i)
        # title += sprintf("\nnpp.%2d%03d.%02d%02d", year[2..3], yday, hour, minute)
        category = "npp"
        where = "POINT(-147.723056 64.843611)"
      when barrow_radar_regexp
        dummy, year, month, day, hour, minute = filename.match(
          barrow_radar_regexp
        ).to_a
        title = "#{year}-#{month}-#{day} #{hour}:#{minute}"
        category = "image"
        where = "POINT(-156.788333 71.2925)"
        #fix date to be local
        date = DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, 0)
        date = fix_time_tz(date, date.to_time.localtime.zone)
      # when barrow_day_animation_regexp
      #   dummy, year, month, day = filename.match(
      #     barrow_day_animation_regexp
      #   ).to_a
      # 
      #   title = "#{year}-#{month}-#{day}"
      #   category = "image"
      #   where = "POINT(-156.788333 71.2925)"
      #   tz = Time.now.strftime('%z')
      when barrow_webcam_regexp
        dummy, year, month, day, hour, minute = filename.match(
          barrow_webcam_regexp
        ).to_a
        title = "#{year}-#{month}-#{day} #{hour}:#{minute}"
        category = "image"
        where = "POINT(-156.788333 71.2925)"
        #fix date to be local
        date = DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, 0)
        date = fix_time_tz(date, date.to_time.localtime.zone)
      else
        #raise "Unable to breakdown filename, #{filename}"
        return nil
      end

      { 
        entry_slug: Entry.build_slug(title), 
        title: title, 
        category: category, 
        year: year, 
        month: month, 
        day: day, 
        hour: hour, 
        minute: minute, 
        where: where,
        date: date
      }
    end
  end
end
