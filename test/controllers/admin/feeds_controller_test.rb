require 'test_helper'

class Admin::FeedsControllerTest < ActionController::TestCase
  def setup
    @feed = feeds(:satellite)
    sign_in users(:admin)
    stub_dragonfly_preview(:thumb, url: "https://example.com/preview")
  end

  test 'it renders index' do
    get :index

    assert_response :success
  end

  test 'it renders edit' do
    get :edit, id: @feed.slug

    assert_response :success
  end

  test 'it updates a feed' do
    patch :update, id: @feed, feed: {
      slug: 'satellite',
      title: 'satellite',
      description: 'satellite description',
      author: 'satellite',
      animate: false,
      active_animations: []
    }

    assert_redirected_to admin_feeds_path
  end

  test 'it renders new' do
    assert_raises ActionView::Template::Error do
      get :new
    end
  end

  test 'it destroys a feed' do
    assert_difference('Feed.count', -1) do
      delete :destroy, id: @feed
    end

    assert_redirected_to admin_feeds_path
  end

  test 'it creates a feed' do
    assert_difference('Feed.count') do
      post :create, feed: {
        slug: 'satellite-create',
        title: 'satellite-create',
        description: 'satellite description -create',
        author: 'satellite-create',
        ingest_slug: 'new-satellite',
        animate: false,
        active_animations: []
      }
    end

    assert_redirected_to admin_feeds_path
  end
end