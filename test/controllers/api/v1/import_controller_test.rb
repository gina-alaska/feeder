require 'test_helper'

class Api::V1::ImportsControllerTest < ActionController::TestCase
  test 'it createss an import' do
    import = imports(:satellite)

    assert_difference('Import.count') do
      @request.headers['token'] = api_keys(:satellite).token
      post :create, feed: import.feed, url: import.url, timestamp: import.timestamp
    end

    assert_response :success
  end
end
