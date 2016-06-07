class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.feed_admin?
      can :manage, Feed
      can :manage, Sensor
      can :manage, WebHook
    end

    if user.job_admin?
      can :manage, Queue
    end

    if user.user_admin?
      can :manage, User
      can :manage, Member
    end

    if user.site_admin?
      can :manage, User
      can :manage, Member
      can :manage, Feed
      can :manage, Sensor
      can :manage, WebHook
      can :manage, Queue
    end

    can :read, :all
  end
end
