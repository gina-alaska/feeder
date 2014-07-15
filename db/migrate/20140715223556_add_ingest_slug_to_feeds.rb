class AddIngestSlugToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :ingest_slug, :string
  end
end
