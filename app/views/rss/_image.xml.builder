content_xml.cdata!(
<<EOHTML
<!-- Radar animation context -->
<style>
img { 
  min-width: 300px; 
  min-height: 500px; 
  width: 100%;
  margin: 0;
  padding: 0;
  border: none;
}
.feed {
  max-width: 960px;
  margins: 0 auto;
}
.logos img {
  width: 150px;
}
</style>
<div class="feed">
  <h1>#{link_to entry.feed.title, slug_url(entry.feed)}</h1>
  <h4>#{link_to entry.title, slug_entry_url(entry.feed, entry)}</h4>
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