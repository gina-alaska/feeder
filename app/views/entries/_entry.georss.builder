entry_xml.entry {
  entry_xml.title entry.title
  entry_xml.summary "#{entry.feed.title} for #{entry.title}"
  
  entry_xml.id feed_entry_url(entry.feed, entry, :format => :georss)
  entry_xml.link(:href => feed_entry_url(entry.feed, entry, :format => :georss), :rel => "self")
  entry_xml.link(:href => feed_entry_url(entry.feed, entry, :format => :html), :rel => "alternate")
  entry_xml.event entry.event_at
  entry_xml.tag!('georss:where') {
    entry_xml << entry.georss_location    
  }
  entry_xml.content(:type=>"xhtml", :src=>feed_entry_url(entry.feed, entry, :format => :html)) {
    entry_xml.text! entry.content      
  }
  entry_xml.updated entry.updated_at
}