class Sensor < ActiveRecord::Base
  # attr_accessible :name, :selected_by_default

  has_many :feeds

  def to_s
    self.name
  end
end
