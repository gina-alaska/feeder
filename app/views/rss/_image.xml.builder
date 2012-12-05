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
}
</style>
#{image_tag(File.join(root_url, entry.preview.try(:thumb, '800x800').try(:url)), alt: entry.title)}
EOHTML
)