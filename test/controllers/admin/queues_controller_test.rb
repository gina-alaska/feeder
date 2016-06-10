require 'test_helper'

class Admin::QueuesControllerTest < ActionController::TestCase
  def setup
    sign_in(users(:admin))
  end

  test 'it renders index' do
    get :index

    assert_response :success
  end

  test 'it renders show' do
    get :show, id: 'queue'

    assert_response :success
  end
end