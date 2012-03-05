xml.instruct! :xml, :version => "1.0"
xml.feed("xmlns"=>"http://www.w3.org/2005/Atom", "xmlns:georss" => "http://www.georss.org/georss") {
  xml.title @feed.title
  xml.subtitle @feed.description
  xml.id slug_url(@feed, :format => :georss)
  xml.link(:href => slug_url(@feed, :format => :georss), :rel => "self")
  xml.link(:href => slug_url(@feed, :format => :html), :rel => "alternate")
  xml.updated @feed.updated_at
  render :partial => @entries, :locals => { :entry_xml => xml }
}