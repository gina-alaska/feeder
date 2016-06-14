class RemoveWhereFromEntry < ActiveRecord::Migration
  def change
    remove_column :entries, :where
  end
end
