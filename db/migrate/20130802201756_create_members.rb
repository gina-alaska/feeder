class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :email
      t.boolean :admin

      t.timestamps
    end
    
    add_column :users, :member_id, :integer
  end
end
