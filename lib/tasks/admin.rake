namespace :admin do
  desc "Give EMAIL all admin privileges"
  task promote: :environment do
    promote_user([:site_admin,:user_admin,:job_admin,:feed_admin])
  end

  desc "Revoke all admin privileges from EMAIL"
  task demote: :environment do
    demote_user([:site_admin,:user_admin,:job_admin,:feed_admin])
  end

  namespace :promote do
    %w{site user feed job}.each do |role|
      desc "Make EMAIL a #{role} admin"
      task "#{role}": :environment do
        promote_user(["#{role}_admin".to_sym])
      end
    end
  end

  namespace :demote do
    %w{site user feed job}.each do |role|
      desc "Revoke EMAIL a #{role} admin privileges"
      task "#{role}": :environment do
        promote_user(["#{role}_admin".to_sym])
      end
    end
  end

  def promote_user(roles)
    modify_user_roles(roles, true)
  end

  def demote_user(roles)
    modify_user_roles(roles, false)
  end

  def modify_user_roles(roles, value=false)
    abort "EMAIL is not set" if ENV['EMAIL'].nil?

    user = User.where(email: ENV['EMAIL']).first
    abort "EMAIL not found" if user.nil?

    params = roles.each_with_object({}) do |role, hash|
      hash[role] = value
    end

    user.update_attributes(params)
  end

end