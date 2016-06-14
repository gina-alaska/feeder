class Feed < ActiveRecord::Base
  include GeoRuby::SimpleFeatures

  validates_presence_of :slug
  validates_uniqueness_of :slug

  # validates_uniqueness_of :ingest_slug

  validates_presence_of :title
  validates_uniqueness_of :title

  has_many :movies
  has_many :web_hooks

  belongs_to :sensor

  has_many :entries do
    def current
      order('event_at DESC').limit(1)
    end
    def latest
      order('event_at DESC')
    end
  end

  has_many :current_entries, -> { order('event_at DESC').limit(1) }, class_name: 'Entry'

  accepts_nested_attributes_for :web_hooks, reject_if: proc { |attrs| attrs['url'].blank? }

  serialize :active_animations

  scope :active, -> { where(status: 'online') }
  scope :animated, -> { where(animate: true) }

  def to_param
    self.slug
  end

  def to_s
    self.title
  end

  def self.generate_animations
    Feed.where(:animate => true).all.each do |f|
      f.queue_animation_ending(Time.now)
    end
  end

  def queue_animation_ending(date, force = false)
    self.active_animations.each do |duration|
      start = (date.beginning_of_day - duration.days).to_date

      movie = self.movies.where(event_at: start, duration: duration.to_i).first
      if movie.nil?
        movie = self.movies.build(:event_at => start, :duration => duration.to_i, :title => "#{duration} day animation")

        if movie.entries.count > 0 && movie.save
          movie.async_generate
        end
      elsif force
        movie.reset
        movie.save
        movie.async_generate
      end
    end
  end

  def show_by_default
    true
  end

  def georss_location
    Geometry.from_ewkt(self.where).as_georss unless self.where.empty?
  end

  def import(url, event_at)
    self.entries.build(
      image_url: url,
      event_at: event_at,
      slug: Entry.build_slug(event_at)
    )
  end
end
