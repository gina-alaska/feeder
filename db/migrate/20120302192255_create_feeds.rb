class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string      :slug
      t.string      :title
      t.string      :description
      t.string      :author
      t.string      :where
      t.timestamps
    end
  end
end
