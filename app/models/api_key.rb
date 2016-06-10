class ApiKey < ActiveRecord::Base
  validates :name, presence: true, allow_blank: false
  validates :token, presence: true, uniqueness: true, allow_blank: false

  def self.generate_token
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      return token unless ApiKey.where(token: token).any?
    end
  end
end
