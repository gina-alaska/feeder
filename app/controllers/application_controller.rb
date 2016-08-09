class ApplicationController < ActionController::Base
  # protect_from_forgery
  layout :set_layout

  check_authorization unless: :special_controller?

  rescue_from CanCan::AccessDenied, with: :handle_permission_denied

  def search
    # fetch feeds if it hasn't been done yet
    @feeds ||= Feed.active
    @sensors ||= Sensor.where(id: @feeds.pluck(:sensor_id))
    @search_path ||= '/search'

    feed_ids = pull_ids(:feeds) || []
    if !selected_sensor_ids or selected_sensor_ids.empty?
      @selected_sensor_ids = @sensors.where(selected_by_default: true).pluck(:id)
    end

    if !selected_feed_ids or selected_feed_ids.empty?
      @selected_feed_ids = @feeds.pluck(:id)
    end

    page = params[:page] || 1

    @entries = Entry.order(event_at: :desc)
    @entries = @entries.where(feed_id: selected_feed_ids) unless selected_feed_ids.empty?
    @entries = @entries.joins(:feed).where("feeds.sensor_id" => selected_sensor_ids) unless selected_sensor_ids.empty?
    @entries = @entries.where('event_at > ?', Time.zone.parse(search_params[:start]).beginning_of_day) unless search_params[:start].blank?
    @entries = @entries.where('event_at < ?', Time.zone.parse(search_params[:end]).beginning_of_day) unless search_params[:end].blank?
    @entries.page(page).per(15)
  end

  protected

  def selected_sensor_ids
    @selected_sensor_ids ||= pull_ids(:sensors)
  end
  helper_method :selected_sensor_ids

  def selected_feed_ids
    @selected_feed_ids ||= pull_ids(:feeds)
  end
  helper_method :selected_feed_ids

  def search_params
    return @search_params unless @search_params.nil?

    @search_params ||= params[:search] || {}

    unless @feed.nil?
      @search_params[:feeds] = {}
      @search_params[:feeds][@feed.id.to_s] = '1'
      @search_params[:sensors] = {}
      @search_params[:sensors][@feed.sensor.try(:id).try(:to_s)] = '1'
    end

    unless @entry.nil?
      @search_params[:end] = @search_params[:start] = @entry.event_at.strftime('%Y/%m/%d')
    end

    @search_params
  end
  helper_method :search_params

  def pull_ids(field)
    return false unless search_params.include?(field)

    items = search_params[field]
    items.inject([]) { |c,i| c << i[0].to_i if i[1].to_i == 1 }
  end

  def redirect_back_or_default(url)
    if session[:redirect_back_location].present?
      redirect_to session.delete(:redirect_back_location)
    else
      redirect_to url
    end
  end

  protected

  def special_controller?
    devise_controller?
  end

  def handle_permission_denied(_exception)
    if signed_in?
      flash[:error] = 'You do not have permission to view this page'
      redirect_to session[:referred_from_url] || request.referer || root_url
    else
      flash[:notice] = 'Please login to perform the reqeuested action'
      save_current_location
      redirect_to new_user_session_path
    end
  end

  def save_current_location
    session[:referred_from_url] = request.referer
    store_location_for(current_user || User.new, request.original_url)
  end

  def save_referrer_location
    store_location_for(current_user || User.new, request.referer)
  end


  private
  def set_layout
    if request.headers['X-PJAX']
      "pjax"
    else
      "application"
    end
  end
end
