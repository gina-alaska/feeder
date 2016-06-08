class ApiKey < ActiveRecord::Base
  validates :name, presence: true, allow_blank: false
  validates :token, presence: true, allow_blank: false
  
  def self.generate_token
    SecureRandom.base64.tr('+/=', 'Qrt')
  end
end
