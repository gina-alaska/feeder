class ChangeDescriptionToText < ActiveRecord::Migration
  def up
    change_column :feeds, :description, :text, :limit => nil
  end

  def down
    change_column :feeds, :description, :string
  end
end
