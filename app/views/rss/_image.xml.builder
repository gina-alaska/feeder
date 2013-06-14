content_xml.cdata!(
<<EOHTML
<!-- Radar animation context -->
<style>
.puffin-feeder img { 
  min-width: 300px; 
  min-height: 500px; 
  width: 100%;
  margin: 0;
  padding: 0;
  border: none;
}
</style>
<div class="puffin-feeder">
  #{image_tag(File.join(root_url, entry.preview.try(:thumb, '800x800').try(:url)), alt: entry.title)}
  <div class="feeder">
  Find more @ <a href="http://feeder.gina.alaska.edu">GINA Puffin Feeder</a>
  </div>
  <div class="powered_by">
    Powered by <a href="http://www.gina.alaska.edu/">GINA</a>
  </div>
</div>
EOHTML
)