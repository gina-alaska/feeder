content_xml.cdata!(
<<EOHTML
<!-- image context -->
#{ render :partial => 'feeds/npp.html.haml', :locals => { feed: @feed, entry: entry } }
EOHTML
)