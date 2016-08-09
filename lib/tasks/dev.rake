require 'httparty'

namespace :dev do
  desc "Set user with email or last user as admin"
  task :admin do
    email = ENV['EMAIL']

    if email.nil?
      u = User.last
    else
      u = User.where(email: email).first
    end

    u.update_attributes(feed_admin: true, user_admin: true, job_admin: true, site_admin: true)
  end
end
