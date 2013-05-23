class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :set_layout
  
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
    @search = search_params
    
    @entries = Entry.search do
      with(:feed_id, selected_feed_ids) unless selected_feed_ids.empty?
      with(:sensor_id, selected_sensor_ids) unless selected_sensor_ids.empty?
      with(:event_at).greater_than(Time.zone.parse(search_params[:start]).beginning_of_day) unless search_params[:start].blank?
      with(:event_at).less_than(Time.zone.parse(search_params[:end]).end_of_day) unless search_params[:end].blank?
      
      facet :sensor_id 
      facet :feed_id
      
      order_by(:event_at, :desc)
      paginate :page => page, :per_page => 15
    end
    
    @facets = {}
    %w{ feed_id sensor_id }.each do |name|
      @entries.facet(name.to_sym).rows.each do |f|
        @facets[name.to_sym] ||= {}
        @facets[name.to_sym][f.value] = f.count      
      end
    end
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
  
  def current_user
    logger.info "User id: #{session[:user_id]}"
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end

  helper_method :current_user, :signed_in?

  def current_user=(user)
    logger.info "Assigning current user #{user.name}"
    @current_user = user
    session[:user_id] = user.id
  end
  
  def redirect_back_or_default(url)
    if session[:redirect_back_location].present?
      redirect_to session.delete(:redirect_back_location)
    else
      redirect_to url
    end
  end
  
  def require_admin_auth
    if current_user.nil?
      session[:redirect_back_location] = request.url
      redirect_to signin_path
    elsif not current_user.admin?
      flash[:error] = 'You do not have permission to access this page'
      redirect_to root_url
    end
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
