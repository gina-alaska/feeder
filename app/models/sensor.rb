class Sensor < ActiveRecord::Base
  has_many :feeds

  def to_s
    self.name
  end
end
