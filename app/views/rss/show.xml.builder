xml.instruct! :xml, :version => "1.0"
xml.rss(:version => "2.0", "xmlns:georss"=>"http://www.georss.org/georss") do
  xml.channel do
    xml.title @feed.title
    xml.description @feed.description
    xml.id georss_url(@feed, :format => :xml)
    xml.link(:href => georss_url(@feed, :format => :xml), :rel => "self")
    xml.link(:href => slug_url(@feed, :format => :html), :rel => "alternate")
    xml.lastBuildDate @feed.updated_at
    render :partial => 'entry', :collection => @entries, :locals => { :entry_xml => xml }
  end
end