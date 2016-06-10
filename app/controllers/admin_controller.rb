class AdminController < ApplicationController
  def current_ability
    Ability.new(current_user, 'admin')
  end
end
