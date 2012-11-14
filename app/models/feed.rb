class Feed < ActiveRecord::Base
  include GeoRuby::SimpleFeatures

  validates_presence_of :slug
  validates_presence_of :title

  has_many :movies

  has_many :entries do
    def current
      order('event_at DESC').limit(1)
    end
  end
  
  serialize :active_animations
  
  def to_param
    self.slug
  end
  
  def self.generate_animations
    Feed.where(:animate => true).all.each do |f|
      f.active_animations.each do |duration|
        date = (Time.now.beginning_of_day - duration.days).to_date
        
        movie = f.movies.where(:event_at => date, :duration => duration.to_i).first
        if movie.nil?
          movie = Movie.new(:event_at => date, :duration => duration.to_i, :title => "#{duration} day animation")
          movie.feed = f
        
          if movie.entries.count > 0 && movie.save
            movie.async_generate        
          end
        end
      end
    end
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
      raise "Unable to find #{item}"
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
        where: metainfo[:where] 
      }

      # unless File.exists?(File.join(path, File.basename(filename)))
      #   FileUtils.mkdir_p(path)
      #   FileUtils.cp(filename, path)
      # end

      if entry.update_attributes(attributes)
        puts "Import complete"
      else
        puts "Import failed"
        puts entry.errors.full_messages
      end

      self.touch
    end
  end
  
  
  class << self
    def import(slug, item, glob = '**/*', type = 'image')
      feed = where(:slug => slug).first
      raise "Unable to find feed for #{slug}" if feed.nil?

      feed.import(item)
    end
  end
end
