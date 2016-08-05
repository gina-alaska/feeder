class ApiController < ApplicationController
  def current_ability
    Ability.new(request.headers['token'], 'api')
  end
end
