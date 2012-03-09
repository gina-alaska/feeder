class Entry < ActiveRecord::Base
  include GeoRuby::SimpleFeatures
  
  # paginates_per 16

  belongs_to :feed

  def self.build_slug(text)
    text.downcase.gsub(/[\-\.:\s]/,'_')
  end
  
  def to_param
    self.slug
  end
  
  def georss_location
    Geometry.from_ewkt(self.where).as_georss unless self.where.empty?
  end  
end
