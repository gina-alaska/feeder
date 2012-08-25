class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string    :title
      t.integer   :feed_id
      t.date      :event_at
      t.integer   :duration # in days
      t.string    :status
      t.string    :path
      t.boolean   :generated, :default => false
      t.timestamps
    end
  end
end
