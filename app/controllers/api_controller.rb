class ApiController < ApplicationController
  protected

  def current_ability
    ApiAbility.new(request.headers['token'])
  end

  def handle_permission_denied(_exception)
    head 403, content_type: 'application/json'
  end
end
