require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  def setup
    @movie = movies(:satellite)
  end

  test 'it renders the index' do
    get :index

    assert_response :success
  end

  test 'it renders searches' do
    get :search

    assert_response :success
  end

  test 'it renders show' do
    get :show, id: @movie, feed_id: @movie.feed.slug
  end
end
