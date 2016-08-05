class ApiAbility
  include CanCan::Ability

  def initialize(token)
    api_key = ApiKey.where(token: token).first || false

    can :manage, Import if api_key
  end
end
