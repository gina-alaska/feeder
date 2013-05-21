class Admin::SensorsController < AdminController
  def index
    @sensors = Sensor.all
  end
  
  def edit
    @sensor = Sensor.find(params[:id])
  end
  
  def update
    @sensor = Sensor.find(params[:id])
    
    respond_to do |format|
      if @sensor.update_attributes(params[:sensor])
        format.html { 
          flash[:success] = "Updated #{@sensor.name}"
          redirect_to admin_sensors_path
        }
      else
        format.html {
          render :edit
        }
      end
    end
  end
  
  def new
    @sensor = Sensor.new
  end
end
