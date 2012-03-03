class Entry < ActiveRecord::Base
  include GeoRuby::SimpleFeatures

  belongs_to :feed
  
  def georss_location
    Geometry.from_ewkt(self.where).as_georss unless self.where.empty?
  end  
end
