class AddSlugToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :slug, :string

  end
end
