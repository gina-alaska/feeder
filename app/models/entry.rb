class Entry < ActiveRecord::Base
  include GeoRuby::SimpleFeatures

  belongs_to :feed, touch: true
  has_many :create_events

  delegate :where, to: :feed

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

  validates_presence_of :slug, uniqueness: true
  validates_presence_of :event_at

  searchable do
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
  alias_method :title, :to_s

  def event_at
    self.read_attribute(:event_at).in_time_zone(zone)
  end

  def zone
    feed.timezone
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
    Geometry.from_ewkt(self.feed.where).as_georss unless self.feed.where.blank?
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

    def fix_time_tz(time, zone)
      DateTime.parse(time.strftime("%Y/%m/%d %H:%M:%S #{zone}"))
    end
  end
end
