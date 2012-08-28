class AddAnimateSettingsToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :animate, :boolean
    add_column :feeds, :active_animations, :string
  end
end
