module ApplicationHelper
  def flash_messages
    output = ""
    flash.each do |type,msg|
      output << content_tag(:div, class: "alert alert-#{type}") do
        "#{msg} #{link_to 'x', '#', class: 'close', "data-dismiss" => "alert"}".html_safe
      end
    end
    output.html_safe
  end
  
  def search_checked?(item, selected = [])
    selected.include?(item.id)
  end
  
  def feed_cdn_url(path= nil)
    if Feeder::Application.config.feed_cdn_urls.nil?
      url = root_url
    else
      url = Feeder::Application.config.feed_cdn_urls[rand(Feeder::Application.config.feed_cdn_urls.count)]
    end
    
    unless path.nil?
      url = File.join(url, path)
    end
      
    url
  end
  
  def cw_image_url(img)
    if img.nil? or img.url.nil?
      'http://placehold.it/200x200&text=Not+available'
    else
      img.url
    end
  end
  
  def feed_select_options
    feeds = Feed.order('slug ASC').inject([]) do |c,f|
      c << [f.title, slug_url(f)] if f.entries.count > 0
      c
    end
    # selected = @feed.nil? ? nil : slug_url(@feed)
    options_for_select(feeds)
  end
  
  def current_date_range(entries)
    if (entries.first.event_at - entries.last.event_at) >= 1.day
      "#{entries.first.event_at.strftime('%Y/%m/%d')} - #{entries.last.event_at.strftime('%Y/%m/%d')}"
    else
      entries.first.event_at.strftime('%Y/%m/%d')
    end
  end
  
  def link_to_prev_page(scope, options = {}, &block)
    # options = name if name.is_a? Hash
    
    disable_class = options.delete(:disable_class) || 'disabled'
    params = options.delete(:params) || {}
    param_name = options.delete(:param_name) || Kaminari.config.param_name

    if scope.first_page?
      options[:class] ||= ''
      options[:data] ||= {}
      options[:class] << " #{disable_class}"
      options[:data][:disabled] = true
      #turn off remote if the button should be disabled
      options[:remote] = false
    end    
    
    link_to params.merge(param_name => (scope.current_page - 1)), options.reverse_merge(:rel => 'previous'), &block
  end
  
  def link_to_next_page(scope, options = {}, &block)
    # options = name if name.is_a? Hash
    
    disable_class = options.delete(:disable_class) || 'disabled'
    params = options.delete(:params) || {}
    param_name = options.delete(:param_name) || Kaminari.config.param_name

    if scope.last_page?
      options[:class] ||= ''
      options[:data] ||= {}
      options[:class] << " #{disable_class}"
      options[:data][:disabled] = true
      #turn off remote if the button should be disabled
      options[:remote] = false
    end
    
    link_to params.merge(param_name => (scope.current_page + 1)), options.reverse_merge(:rel => 'previous'), &block
  end
end
