entry_xml.item {
  entry_xml.title entry.title
  
  entry_xml.id slug_entry_url(entry.feed, entry, :format => :georss)
  entry_xml.link(:href => slug_entry_url(entry.feed, entry, :format => :georss), :rel => "self")
  entry_xml.link(:href => slug_entry_url(entry.feed, entry, :format => :html), :rel => "alternate")
  entry_xml.event entry.event_at
  entry_xml << entry.georss_location    
  
  entry_xml.description {
    entry_xml.cdata! entry.content      
  }
  entry_xml.pubDate entry.updated_at
}