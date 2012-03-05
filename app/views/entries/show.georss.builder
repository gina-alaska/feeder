xml.instruct! :xml, :version => "1.0"
xml.feed("xmlns"=>"http://www.w3.org/2005/Atom", "xmlns:georss" => "http://www.georss.org/georss") {
  xml.title @feed.title
  xml.description @feed.description
  xml.id feed_url(@feed, :format => :georss)
  xml.link(:href => feed_url(@feed, :format => :georss), :rel => "self")
  xml.link(:href => feed_url(@feed, :format => :html), :rel => "alternate")
  xml.updated @feed.updated_at
  render :partial => @entry, :locals => { :entry_xml => xml }
}