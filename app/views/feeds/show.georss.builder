xml.instruct! :xml, :version => "1.0"
xml.feed("xmlns:georss" => "http://www.georss.org/georss", "xmlns:gml"=> "http://www.opengis.net/gml") {
  xml.title @feed.title
  xml.description @feed.description
  xml.id feed_url(@feed, :format => :georss)
  xml.link(:href => feed_url(@feed))
  xml.updated @feed.updated_at
  xml.tag!('georss:where') {
    xml << @feed.georss_location
  }
  render :partial => @feed.entries.order('event_at ASC'), :locals => { :entry_xml => xml }
}