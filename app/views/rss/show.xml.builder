xml.instruct! :xml, :version => "1.0"
xml.rss(:version => "2.0", "xmlns:georss"=>"http://www.georss.org/georss") do
  xml.channel do
    xml.title "GINA Puffin Feeder"
    xml.description @feed.description
    xml.id slug_url(@feed, :format => :xml)
    xml.link root_url
    xml.link(:href => georss_url(@feed, :format => :xml), :rel => "alternate")
    xml.lastBuildDate @feed.updated_at
    render :partial => 'entry', :collection => @entries, :locals => { :entry_xml => xml }
  end
end