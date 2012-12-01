class AddPreviewNameFieldToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :preview_name, :string
  end
end
