# GINA Feeder

A GeoRSS generator and data browser.

## Installation

    bundle install                # Install the gems
    vi config/database.yml        # Setup database configs
    ln /data/feeder_uploads public/uploads
                                  # Setup upload directory for thumbnails
    rake db:setup                 # Create, load and initialize the database
    rails server                  # Start the server
    
Open a browser and point at http://localhost:3000
