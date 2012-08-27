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
  
  
  def collase_current_slug_without_date(slug)
    if current_page?(slug_path(slug: slug)) && params.include?(:date)
      ""
    else
      "collapse"
    end
  end
end
