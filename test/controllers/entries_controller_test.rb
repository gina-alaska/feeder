require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  def setup
    @feed = feeds(:satellite)
    @entry = @feed.entries.first

    @preview = OpenStruct.new(
      png: OpenStruct.new(url: 'https://example.com/png'),
      jpg: OpenStruct.new(url: 'https://example.com/jpg')
    )
  end

  test "should render a feed entry" do
    get :show, slug: @feed.slug, id: @entry.slug

    assert_response :success
  end

  test 'should render current feed entry' do
    get :show, slug: @feed.slug, id: 'current'

    assert_response :success
  end

  test "404 when no entry is found" do
    get :show, slug: @feed.slug, id: 'no-entry-found'

    assert_response :not_found
  end

  test 'it renders an image' do
    get :image, slug: @feed.slug, id: @entry.slug

    assert_response :success
  end

  test 'it renders the current image' do
    get :image, slug: @feed.slug, id: 'current'

    assert_response :success
  end

  test 'it renders embedded images' do
    get :embed, slug: @feed.slug, id: @entry.slug, format: 'js'

    assert_response :success
  end

  test 'it renders the current embedded image' do
    get :embed, slug: @feed.slug, id: 'current', format: 'js'

    assert_response :success
  end

  test 'it renders preview images' do
    Entry.any_instance.stubs(:preview).returns(@preview)
    get :preview, slug: @feed.slug, id: @entry.slug, format: 'jpg'

    assert_response :redirect
  end

  test 'it renders the current preview image' do
    Entry.any_instance.stubs(:preview).returns(@preview)
    get :preview, slug: @feed.slug, id: 'current', format: 'jpg'

    assert_response :redirect
  end

  test 'it searches' do
    get :search

    assert_response :success
  end

  test 'it render json list of entries' do
    get :search, format: :json

    assert_response :success
  end
end
