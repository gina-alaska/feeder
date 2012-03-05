class Entry < ActiveRecord::Base
  include GeoRuby::SimpleFeatures
  
  self.per_page = 16

  belongs_to :feed
  
  def to_param
    self.title
  end
  
  def georss_location
    Geometry.from_ewkt(self.where).as_georss unless self.where.empty?
  end  
end
