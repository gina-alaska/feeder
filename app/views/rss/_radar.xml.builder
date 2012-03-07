content_xml.cdata!(
<<EOHTML
<!-- Radar animation context -->
<div class="puffin_feeder" style="text-align: center;">
  <a href="#{File.join(root_url,entry.file)}" target="_blank"><img src="#{File.join(root_url,entry.file)}" alt="#{entry.title}" style="width:200px" /></a>
</div>
EOHTML
)