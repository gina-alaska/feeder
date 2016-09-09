require 'test_helper'

class Api::V1::ImportsControllerTest < ActionController::TestCase
  test 'should create an import' do
    import = imports(:satellite)

    assert_difference('Import.count') do
      @request.headers['token'] = api_keys(:satellite).token
      post :create, feed: import.feed, url: import.url, timestamp: import.timestamp
    end

    assert_response :success
  end

  test 'should deny access to create import' do
    import = imports(:satellite)

    post :create, feed: import.feed, url: import.url, timestamp: import.timestamp
    assert_response :forbidden
  end
end
