entry_xml.item {
  entry_xml.title entry.title
  
  entry_xml.id georss_entry_url(entry.feed, entry, :format => :xml)
  entry_xml.link slug_entry_url(entry.feed, entry, :format => :html)
  entry_xml.link(:href => slug_entry_url(entry.feed, entry, :format => :html), :rel => "alternate")
  entry_xml.event entry.event_at.rfc822
  entry_xml << entry.georss_location    
  
  entry_xml.image File.join(root_url, entry.preview.try(:thumb,'800x800').try(:url))
  entry_xml.description {
    if params[:rss]
      render :partial => 'iframe', :locals => { :content_xml => entry_xml, :entry => entry }
    else
      render :partial => 'image', :locals => { :content_xml => entry_xml, :entry => entry }
    end
  }
  entry_xml.pubDate entry.updated_at.rfc822
}
