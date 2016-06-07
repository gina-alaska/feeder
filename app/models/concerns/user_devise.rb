module UserDevise
  extend ActiveSupport::Concern

  module ClassMethods
    def omniauth_providers
      providers = [:gina_id]
      providers << :developer unless Rails.env.production?

      providers
    end

    def from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name # assuming the user model has a name
      end
    end

    def new_with_session(params, session)
      super.tap do |user|
        # This is based on the Devise/OmniAuth Example
        # rubocop:disable Lint/AssignmentInCondition
        if data = session["devise.open_id_data"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end
  end

  included do
    devise :database_authenticatable, :rememberable,
           :trackable, :validatable, :omniauthable,
           omniauth_providers: omniauth_providers
  end
end