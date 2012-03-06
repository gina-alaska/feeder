class AddAdditionalEntryFields < ActiveRecord::Migration
  def change 
    add_column :entries, :file, :string
    add_column :entries, :category, :string
  end
end
