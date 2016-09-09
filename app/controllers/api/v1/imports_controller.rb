class Api::V1::ImportsController < ApiController
  before_action :load_feed
  authorize_resource

  def create
    import = Import.new(import_params)

    if import.save!
      import.queue!
      head 200, content_type: 'application/json'
    else
      head 503, content_type: 'application/json'
    end
  end

  private
  def load_feed
    @feed = Feed.find_by(slug: params[:feed])
  end

  def import_params
    params.permit(:feed, :url, :timestamp)
  end
end
