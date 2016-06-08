class Feed < ActiveRecord::Base
  include GeoRuby::SimpleFeatures

  validates_presence_of :slug
  validates_uniqueness_of :slug

  validates_uniqueness_of :ingest_slug

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

  def self.async_import(slug, file)
    Resque.enqueue(ImportWorker, slug, file)
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

  def import(item)
    if File.directory? item
      files = Dir.glob(File.join(item, '**/*'))
    elsif File.exists? item
      files = [item]
    else
      puts "Unable to find #{item}"
      return false
    end

    files.each do |filename|
      next if File.basename(filename)[0] == ?.
      next if File.directory? filename

      file = File.basename(filename)
      metainfo = Entry.metainfo(file)
      next if metainfo.nil?

      puts "Importing #{file}"

      entry = self.entries.where(slug: metainfo[:entry_slug]).first
      entry ||= self.entries.build

      attributes = {
        slug: metainfo[:entry_slug],
        title: metainfo[:title],
        image: File.open(filename),
        category: metainfo[:category],
        event_at: metainfo[:date],
        where: metainfo[:where].blank? ? self.where : metainfo[:where]
      }

      # unless File.exists?(File.join(path, File.basename(filename)))
      #   FileUtils.mkdir_p(path)
      #   FileUtils.cp(filename, path)
      # end

      if entry.update_attributes(attributes)
        entry.async_generate_create_event
        puts "Import complete"
      else
        puts "Import failed"
        puts entry.errors.full_messages
      end

      self.touch
    end
  end

  def accepts_file?(filename)
    info = Feed.ingest_file_info(filename)
    return false if info.nil?

    if info[:ingest_slug].present?
      self.ingest_slug == info[:ingest_slug]
    else
      false
    end
  end

  def ingest(metadata)
    if metadata[:filename].present? and accepts_file?(metadata[:filename])
      entry = self.entries.where(slug: metadata[:slug]).first
      entry ||= self.entries.build

      metadata.delete(:ingest_slug)
      filename = metadata.delete(:filename)
      metadata[:image] = File.open(filename)

      if entry.update_attributes(metadata)
        entry.async_generate_create_event
        puts "Import complete"
      else
        puts "Import failed"
        puts entry.errors.full_messages
      end

      self.touch
    end
  end

  class << self
    def ingest_file_info(filename)
      file_regexp = /^([A-Za-z0-9]+)_(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})(\d{2})\.(\w+)$/
      matched, ingest_slug, year, month, day, hour, minute, seconds, format = File.basename(filename).match(file_regexp).to_a

      return nil if matched.nil?

      date = DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, seconds.to_i, 'UTC')

      {
        slug: Entry.build_slug(date.to_s),
        title: date.to_s,
        filename: filename,
        ingest_slug: ingest_slug,
        event_at: date
      }
    end

    def ingest(filename)
      info = ingest_file_info(filename)
      return false if info.nil?

      feed = Feed.where(ingest_slug: info[:ingest_slug]).first

      unless feed.nil?
        feed.ingest(info)
      end
    end

    def import(slug, item, glob = '**/*', type = 'image')
      feed = where(slug: slug).first
      raise "Unable to find feed for #{slug}" if feed.nil?

      feed.import(item)

      feed
    end
  end
end
