require 'test_helper'

class Admin::JobsControllerTest < ActionController::TestCase
  def setup
    login_user(:admin)
  end

  test 'it destroys a job' do
    post :destroy, id: 'sidekiq-job'

    assert_response :redirect
  end

  test 'it retries a job' do
    post :retry, id: 'sidekiq-job'

    assert_response :redirect
  end
end