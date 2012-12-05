class AddStatusToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :status, :string, default: 'online'
  end
end
