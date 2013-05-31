class CreateAdminSensors < ActiveRecord::Migration
  def up
    create_table :sensors do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :feeds, :sensor_id, :integer
    
    Sensor.create(name: 'Webcam')
    Sensor.create(name: 'Radar')
    Sensor.create(name: 'VIIRS')
    Sensor.create(name: 'MODIS')
  end
  
  def down
    drop_table :sensors
    remove_column :feeds, :sensor_id
  end
end
