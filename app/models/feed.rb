class Feed < ActiveRecord::Base
  include GeoRuby::SimpleFeatures

  validates_presence_of :slug
  validates_presence_of :title

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
  
  def import_image(item)
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
      metainfo = Entry.metainfo(file)
      next if metainfo.nil?
        
      puts "Importing #{file}"  


      entry = self.entries.where(slug: metainfo[:entry_slug]).first
      entry ||= self.entries.build

      attributes = {
        slug: metainfo[:entry_slug],
        title: metainfo[:title],
        file: File.open(filename),
        category: metainfo[:category],
        event_at: DateTime.new(metainfo[:year].to_i, metainfo[:month].to_i, metainfo[:day].to_i, metainfo[:hour].to_i, metainfo[:minute].to_i, 0),
        where: metainfo[:where] 
      }

      # unless File.exists?(File.join(path, File.basename(filename)))
      #   FileUtils.mkdir_p(path)
      #   FileUtils.cp(filename, path)
      # end

      entry.update_attributes(attributes)

      self.touch
    end
  end
  
  
  class << self
    def import(slug, item, glob = '**/*', type = 'image')
      feed = where(:slug => slug).first
      raise "Unable to find feed for #{slug}" if feed.nil?

      case type.to_sym 
      when :image
        feed.import_image(item)
      end
    end
  end
end
