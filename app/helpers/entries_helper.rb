module EntriesHelper
  def preview_image_tag(entry)
    case cookies[:preview_size]
    when 'laptop'
      thumb = entry.preview.thumb('500x500')
    when 'desktop'
      thumb = entry.preview
    when 'mobile'
      thumb = entry.preview.thumb('300x300')
    else
      thumb = entry.preview.thumb('500x500')        
    end
      image_tag thumb.url, class: cookies[:preview_size], height: thumb.height, width: thumb.width
  end
end
