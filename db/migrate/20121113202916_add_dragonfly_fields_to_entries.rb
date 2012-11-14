class AddDragonflyFieldsToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :image_uid, :string
    add_column :entries, :image_name, :string
    add_column :entries, :preview_uid, :string
  end
end
