require 'dragonfly'
require 'geotiff_processor'

app = Dragonfly[:images]
app.configure_with(:imagemagick)
app.configure_with(:rails)

app.processor.register(GeotiffProcessor)

app.define_macro(ActiveRecord::Base, :image_accessor)

app.datastore.configure do |d|
  d.root_path = Rails.root.join('public', 'uploads', 'dragonfly').to_s   # defaults to /var/tmp/dragonfly
  d.server_root = Rails.root.join('public').to_s       # filesystem root for serving from - default to nil
  d.store_meta = true                            # default to true - can be switched off to avoid
                                                  #  saving an extra .meta file if meta not needed
end

