class Feed < ActiveRecord::Base
  include GeoRuby::SimpleFeatures

  has_many :entries
  
  def to_param
    self.slug
  end
  
  def georss_location
    Geometry.from_ewkt(self.where).as_georss unless self.where.empty?
  end
end
