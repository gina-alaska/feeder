class Entry < ActiveRecord::Base
  include GeoRuby::SimpleFeatures
  
  # paginates_per 16

  belongs_to :feed, touch: true

  image_accessor :image do |a|
    copy_to(:preview) do |a|
      if a.format == :tif
      	a.process(:layer, 0, :jpg).thumb('3000x3000>')
      else
 	      a.encode(:jpg).thumb('3000x3000')
      end
    end
  end
  image_accessor :preview do |a|
    after_assign { |a| a.name = "#{a.basename}.jpg" }
  end

  validates_presence_of :slug
  validates_presence_of :title
  validates_presence_of :event_at
  
  def to_param
    self.slug
  end
  
  def to_s
    "#{event_at.strftime('%Y-%m-%d %H:%M %Z')} (JD#{event_at.yday})"
  end
  
  def event_at
    self.read_attribute(:event_at).in_time_zone(self.zone)
  end
  
  def zone
    case entry_type?
    when :barrow_radar_image
      'Alaska'
    when :barrow_webcam
      'Alaska'
    else
      'UTC'
    end
  end
  
  def entry_type?
    if @entry_type.nil?
      self.class.regexps.each do |k,v|
        @entry_type = k if self.image.name.to_s =~ Regexp.new(v)
      end
    end
    @entry_type
  end
  
  def georss_location
    Geometry.from_ewkt(self.where).as_georss unless self.where.empty?
  end
  
  def next
    self.feed.entries.where('event_at > ?', self.event_at).last      
  end
  
  def prev
    self.feed.entries.where('event_at < ?', self.event_at).first      
  end

  class << self
    def build_slug(text)
      text.downcase.gsub(/[\-\.:\s]/,'_').gsub(/[\(\)]/, '')
    end
    
    def regexps
      {
        :modis              => '^[at]1\.(\d{4})(\d{2})(\d{2})\.(\d{2})(\d{2})([_\d\w]+)\.alaska_albers\.tif$',
        :npp                => '^npp\.(\d{2})(\d{3})\.(\d{2})(\d{2})([_\d\w]+)\.tif$',
        :barrow_radar_image => '^SIR_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})_masked\.png$',
        :barrow_webcam      => '^ABCam_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})\.jpg$'
      }
    end
    
    def fix_time_tz(time, zone)
      DateTime.parse(time.strftime("%Y/%m/%d %H:%M:%S #{zone}"))
    end

    def npp_regexp
      Regexp.new(regexps[:npp])
    end
    
    def modis_regexp
      Regexp.new(regexps[:modis])
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
    
    def modis_info(filename)
      dummy, year, month, day, hour, minute = filename.match(modis_regexp).to_a
      date = DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, 0, 'UTC')
      
      {
        year: date.year,
        month: date.month,
        day: date.day,
        hour: date.hour,
        minute: date.minute,
        date: date,
        title: sprintf("%4d-%02d-%02d %02d:%02d (JD%3d)", date.year, date.month, date.day, date.hour, date.minute, date.yday),
        category: 'npp',
        where: "POINT(-147.723056 64.843611)"  
      }
    end
    
    def npp_info(filename)
      dummy, year, yday, hour, minute = filename.match(npp_regexp).to_a
      date = DateTime.strptime("#{year}-#{yday} #{hour}:#{minute} UTC", "%y-%j %H:%M %Z")
      
      
      {
        year: date.year,
        month: date.month,
        day: date.day,
        hour: date.hour,
        minute: date.minute,
        date: date,
        title: sprintf("%4d-%02d-%02d %02d:%02d (JD%3d)", date.year, date.month, date.day, date.hour, date.minute, date.yday),
        category: 'npp',
        where: "POINT(-147.723056 64.843611)"  
      }
    end

    def metainfo(filename)      
      case filename
      when modis_regexp
        info = modis_info(filename)
      when npp_regexp
        info = npp_info(filename)
      when barrow_radar_regexp
        dummy, year, month, day, hour, minute = filename.match(barrow_radar_regexp).to_a
        #fix date to be local
        date = DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, 0)
        date = fix_time_tz(date, date.to_time.localtime.zone)

        info = {
          year: date.year,
          month: date.month,
          day: date.day,
          hour: date.hour,
          minute: date.minute,
          date: date,
          title: "#{year}-#{month}-#{day} #{hour}:#{minute}",
          category: 'image',
          where: "POINT(-156.788333 71.2925)"
        }
      when barrow_webcam_regexp
        dummy, year, month, day, hour, minute = filename.match(barrow_webcam_regexp).to_a
        #fix date to be local
        date = DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, 0)
        date = fix_time_tz(date, date.to_time.localtime.zone)
        
        info = {
          year: date.year,
          month: date.month,
          day: date.day,
          hour: date.hour,
          minute: date.minute,
          date: date,
          title: "#{year}-#{month}-#{day} #{hour}:#{minute}",
          category: 'image',
          where: "POINT(-156.788333 71.2925)"
        }
      else
        raise "Unable to breakdown filename, #{filename}"
        return nil
      end

      info[:entry_slug] = Entry.build_slug(info[:title])
      info
    end
  end
end
