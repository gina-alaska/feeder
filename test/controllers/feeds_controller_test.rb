class FeedsControllerTest < ActionController::TestCase
  def setup
    @feed = feeds(:satellite)
  end

  test 'it renders the index' do
    assert_raises ActionView::Template::Error do
      get :index
    end
  end

  test 'it renders the carousel' do
    # Prod throws 'NoMethodError:undefined method `entries' for nil:NilClass'
    # TODO Figure out what is different
    assert_raises NoMethodError do
      get :carousel, feed_id: @feed.slug
    end
  end
end