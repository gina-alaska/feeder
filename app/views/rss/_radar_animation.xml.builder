content_xml.cdata!(
<<EOHTML
<!-- Radar animation context -->
<style>
.gina_feeder { 
  min-width: 300px; 
  min-height: 500px; 
  height: 100%; 
  width: 100%;
  margin: 0;
  padding: 0;
  border: none;
</style>
<iframe src="#{slug_entry_url(@feed, entry)}" class="gina_feeder" frameborder="0"></iframe> 
EOHTML
)
