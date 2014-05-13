class CreateWebHooks < ActiveRecord::Migration
  def change
    create_table :web_hooks do |t|
      t.string :url, null: false
      t.boolean :active, default: true
      t.integer :feed_id

      t.timestamps
    end
  end
end
