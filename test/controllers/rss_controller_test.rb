class RssControllerTest < ActionController::TestCase
  def setup
    @feed = feeds(:satellite)

    stub_dragonfly_preview(:thumb, url: "https://example.com/thumb")
  end

  test 'it renders show' do
    get :show, slug: @feed.slug, format: 'xml'

    assert_response :success
  end

  test 'it renders current show' do
    get :show, slug: @feed.slug, id: 'current', format: 'xml'

    assert_response :success
  end

  test 'it renders show with an id' do
    get :show, slug: @feed.slug, id: @feed.entries.first.slug, format: 'xml'

    assert_response :success
  end
end
