entry_xml.entry {
  entry_xml.title entry.title
  entry_xml.id feed_entry_url(entry.feed, entry, :format => :georss)
  entry_xml.link(:href => feed_entry_url(entry.feed, entry), :ref => "self")
  entry_xml.event entry.event_at
  entry_xml.tag!('georss:where') {
    entry_xml << entry.georss_location    
  }
  
  entry_xml.content(:type=>"application/xhtml+xml", "xml:lang"=>"en") {
    entry_xml.div(:xmlns=>"http://www.w3.org/1999/xhtml") {
      entry_xml << entry.content      
    }
  }
  entry_xml.updated entry.updated_at
}