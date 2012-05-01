class Entry < ActiveRecord::Base
  include GeoRuby::SimpleFeatures
  
  # paginates_per 16

  belongs_to :feed

  mount_uploader :file, EntryFileUploader

  def self.build_slug(text)
    text.downcase.gsub(/[\-\.:\s]/,'_')
  end
  
  def to_param
    self.slug
  end
  
  def georss_location
    Geometry.from_ewkt(self.where).as_georss unless self.where.empty?
  end  

  class << self
    def npp_regexp
      /^npp\.(\d{2})(\d{3}).(\d{2})(\d{2})_truecolor_aa_1500\.png$/
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
      when npp_regexp
        dummy, year, yday, hour, minute = filename.match(npp_regexp).to_a
        date = DateTime.strptime("#{year}-#{yday}", "%y-%j")
        day = date.day
        month = date.month
        year = date.year
        title = "#{year}-#{month}-#{day} #{hour}:#{minute}"
        category = "image"
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
