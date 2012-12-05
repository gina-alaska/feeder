entry_xml.item {
  entry_xml.title entry.title
  
  entry_xml.id georss_entry_url(entry.feed, entry, :format => :xml)
  entry_xml.link slug_entry_url(entry.feed, entry, :format => :html)
  entry_xml.link(:href => slug_entry_url(entry.feed, entry, :format => :html), :rel => "alternate")
  entry_xml.event entry.event_at.rfc822
  entry_xml << entry.georss_location    
  
  entry_xml.image cw_image_url(entry.file.thumb)
  entry_xml.description {
    render :partial => 'image', :locals => { :content_xml => entry_xml, :entry => entry }
  }
  entry_xml.pubDate entry.updated_at.rfc822
}