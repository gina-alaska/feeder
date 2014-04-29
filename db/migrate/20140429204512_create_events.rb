class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :web_hook_id
      t.integer :entry_id
      t.string :response
      t.string :type

      t.timestamps
    end
  end
end
