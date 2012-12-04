module FeedsHelper
  def all_images_active_class(slug)
    if current_page?(slug_path(slug: slug)) && params[:id].nil? && params[:date].nil?
      "active"
    end
  end
  
  def current_image_active_class(slug)
    if current_page?(slug_entry_path(slug: slug, id: "current"))
      "active"
    end
  end
  
  def month_images_active_class(slug, date)
    if current_page?(slug_path(slug: slug, date: date))
      "active"
    end
  end
  
  def current_feed?(feed)
    current_page?(slug: feed.slug) or current_page?(feed_id: feed.slug) or current_page?(id: feed.slug)
  end
  
  def collapse_current_slug_without_date(slug)
    if current_page?(slug_path(slug: slug)) && params.include?(:date)
      ""
    else
      "collapse"
    end
  end
  
  def keyword_counts(keywords)
    total = 0
    counts = {}
    Feed.all.each do |f|
      next if f.current_entries.empty?
      keywords.each do |kw|
        counts[kw] ||= 0
        if f.title =~ /#{kw}/
          counts[kw] += 1
          total += 1
        end
      end
    end
    
    return [total, counts]
  end
end
