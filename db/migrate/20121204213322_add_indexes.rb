class AddIndexes < ActiveRecord::Migration
  def change
    add_index(:feeds, :slug)
    add_index(:feeds, :updated_at)
    add_index(:entries, :slug)
    add_index(:entries, :updated_at)
  end
end
