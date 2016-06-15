class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :token, null: false
      t.string :name, unique: true
      t.boolean :enabled, default: true
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
