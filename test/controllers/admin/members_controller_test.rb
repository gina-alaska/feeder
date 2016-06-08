require 'test_helper'

class Admin::MembersControllerTest < ActionController::TestCase
  def setup
    login_user(:admin)
  end

  test 'it renders index' do
    get :index

    assert_response :success
  end

  test 'it renders edit' do
    get :edit, id: members(:admin)

    assert_response :success
  end

  test 'it updates members' do
    patch :update, id: members(:admin), member: {
      name: 'update', email: 'update@example.com', admin: false
    }

    assert_response :redirect
  end

  test 'it renders new' do
    get :new

    assert_response :success
  end

  test 'it creates a new member' do
    post :create, member: {
      name: 'new-member', email: 'new-member@example.com', admin: false
    }

    assert_response :redirect
  end
end