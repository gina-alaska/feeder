class AddSelectedByDefaultToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :selected_by_default, :boolean, default: true
  end
end
