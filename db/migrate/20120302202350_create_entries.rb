class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer     :feed_id
      t.string      :title
      t.text        :content
      t.string      :where
      t.datetime    :event_at
      t.timestamps
    end
  end
end
