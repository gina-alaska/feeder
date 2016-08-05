class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :url
      t.datetime :timestamp
      t.string :feed

      t.timestamps null: false
    end
  end
end
