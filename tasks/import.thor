class Import < Thor
  desc "radar SLUG FILENAME", "import radar image into feeds"
  def radar(slug, filename)
    puts slug
    puts filename
  end
end
