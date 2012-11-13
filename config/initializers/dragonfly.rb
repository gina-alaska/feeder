require 'dragonfly'
require 'geotiff_processor'

app = Dragonfly[:images]
app.configure_with(:imagemagick)
app.configure_with(:rails)
app.processor.register(GeotiffProcessor)

app.datastore.configure do |d|
  d.root_path = Rails.root.join('public/uploads/dragonfly').to_s
end

app.define_macro(ActiveRecord::Base, :image_accessor)
