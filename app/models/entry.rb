class Entry < ActiveRecord::Base
  include GeoRuby::SimpleFeatures

  # paginates_per 16

  belongs_to :feed, touch: true
  has_many :create_events

  image_accessor :image do |a|
    copy_to(:preview) do |a|
      if a.format == :tif
      	a.process(:layer, 1, :jpg).thumb('5000x5000>')
      else
 	      a.encode(:jpg).thumb('5000x5000>')
      end
    end
  end
  image_accessor :preview do |a|
    after_assign { |a| a.name = "#{a.basename}.jpg" }
  end

  validates_presence_of :slug
  validates_presence_of :title
  validates_presence_of :event_at

  searchable do
    text :title
    text :slug
    text :feed
    time :event_at

    integer :feed_id
    integer :sensor_id do
      self.try(:feed).try(:sensor).try(:id)
    end
  end

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
    Geometry.from_ewkt(self.feed.where).as_georss unless self.where.blank?
  end

  def next
    self.feed.entries.latest.where('event_at > ?', self.event_at).last
  end

  def prev
    self.feed.entries.latest.where('event_at < ?', self.event_at).first
  end

  def async_generate_create_event
    CreateEventWorker.perform_async(self.id)
  end

  def notify_webhooks(resend = false)
    self.feed.web_hooks.active.each do |wh|
      ce = self.create_events.where(web_hook_id: wh.id).first_or_initialize
      if ce.new_record? or resend
        ce.save
        ce.async_notify
      end
    end
  end

  class << self
    def build_slug(text)
      text.downcase.gsub(/[\-\.:\s]/,'_').gsub(/[\(\)]/, '')
    end

    def regexps
      {
        :modis              => '^[at]1\.(\d{4})(\d{2})(\d{2})\.(\d{2})(\d{2})([_\d\w]+)\.alaska_albers\.tif$',
        :npp                => '^npp\.(\d{2})(\d{3})\.(\d{2})(\d{2})([_\d\w]+)\.tif$',
        :barrow_radar_image => '^SIR_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})_(\w+)\.(\w+)$',
        :barrow_webcam      => '^ABCam_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})\.jpg$',
        :generic            => '^(\w+)_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})\.(\w+)$'
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

    def generic_regexp
      Regexp.new(regexps[:generic])
    end

    def generic_info(filename)
      dummy, import_slug, year, month, day, hour, minute, format = filename.match(generic_regexp)
      date = DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, 0, 'UTC')

      {
        import_slug: import_slug,
        year: date.year,
        month: date.month,
        day: date.day,
        hour: date.hour,
        minute: date.minute,
        date: date,
        title: date.to_s,
        category: category,
        where: ""
      }
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
        date = DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, 0, 'UTC')
        # date = fix_time_tz(date, date.to_time.localtime.zone)

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
      when generic_regexp
        info = generic_info(filename)
      else
        raise "Unable to breakdown filename, #{filename}"
        return nil
      end

      info[:entry_slug] = Entry.build_slug(info[:title])
      info
    end
  end
end
