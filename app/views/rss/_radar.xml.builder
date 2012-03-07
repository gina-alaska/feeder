content_xml.cdata!(
<<EOHTML
<!-- Radar animation context -->
<div class="puffin_feeder" style="text-align: center;">
  <div style="font-size: 1.2em;">#{entry.title}</div>
  <div style="font-size: 1em;">#{link_to 'GINA Puffin Feeder', slug_url(entry.feed), :target => :_blank}</div>
  <a href="#{File.join(root_url,entry.file)}" target="_blank"><img src="#{File.join(root_url,entry.file)}" alt="#{entry.title}" style="width:200px" /></a>
</div>
EOHTML
)