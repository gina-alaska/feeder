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
    
    def npp_regexp
      /^npp\.(\d{2})(\d{3})\.(\d{2})(\d{2})_truecolor-pan_alaska\.tif$/
    end
    
    def npp_landcover_regexp
      /^npp\.(\d{2})(\d{3})\.(\d{2})(\d{2})_I03_I02_I01\.tif$/
    end

    def barrow_radar_regexp
      /^SIR_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2}).png$/
    end

    def barrow_day_animation_regexp
      /^(\d{4})(\d{2})(\d{2})_day.gif/
    end

    def barrow_webcam_regexp
      /^ABCam_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2}).jpg$/
    end

    def metainfo(filename)
      case filename
      when npp_landcover_regexp
        dummy, year, yday, hour, minute = filename.match(npp_landcover_regexp).to_a
        date = DateTime.strptime("#{year}-#{yday}", "%y-%j")
        day = date.day
        month = date.month
        year = date.year
        title = sprintf("%4d-%02d-%02d %02d:%02d (JD%3d)", year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, yday.to_i)
        # title += sprintf("\nnpp.%2d%03d.%02d%02d", year[2..3], yday, hour, minute)
        category = "npp"
        where = "POINT(-147.723056 64.843611)"
      when npp_regexp
        dummy, year, yday, hour, minute = filename.match(npp_regexp).to_a
        date = DateTime.strptime("#{year}-#{yday}", "%y-%j")
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
      when barrow_day_animation_regexp
        dummy, year, month, day = filename.match(
          barrow_day_animation_regexp
        ).to_a

        title = "#{year}-#{month}-#{day}"
        category = "image"
        where = "POINT(-156.788333 71.2925)"
      when barrow_webcam_regexp
        dummy, year, month, day, hour, minute = filename.match(
          barrow_webcam_regexp
        ).to_a
        title = "#{year}-#{month}-#{day} #{hour}:#{minute}"
        category = "image"
        where = "POINT(-156.788333 71.2925)"
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
        where: where
      }
    end
  end
end
