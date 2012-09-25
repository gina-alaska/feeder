class AddDragonFlyFieldsToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :image_uid, :string
    add_column :entries, :image_jpg_uid, :string
    add_column :entries, :image_preview_uid, :string
  end
end
