require 'test_helper'

class Admin::WebHooksControllerTest < ActionController::TestCase
  def setup
    @webhook = web_hooks(:active)
    @feed = @webhook.feed
    
    sign_in(users(:admin))
  end

  test 'it renders index' do
    get :index, feed_id: @feed

    assert_response :success
  end

  test 'it renders show' do
    get :show, id: @webhook, feed_id: @feed

    assert_response :success
  end

  test 'it renders edit' do
    get :edit, id: @webhook, feed_id: @feed

    assert_response :success
  end

  test 'it creates a hook' do
    # WebHook Controller does nothing at the moment
    # assert_difference('WebHook.count') do
    #   post :create, feed_id: @feed, web_hook: {
    #     url: 'https://example.com/new_hook',
    #     active: true
    #   }
    # end

    post :create, feed_id: @feed

    assert_response :redirect
  end

  test 'it updates a hook' do
    patch :update, id: @webhook, feed_id: @feed, web_hook: {
      url: 'https://example.com/updated',
      active: false
    }

    assert_response :redirect
  end

  test 'it destroys a hook' do
    post :destroy, id: @webhook, feed_id: @feed

    assert_response :redirect
  end
end
