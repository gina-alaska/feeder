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
  
  def create
    @sensor = Sensor.new(params[:sensor])
    
    respond_to do |wants|
      if @sensor.save
        flash[:notice] = 'Sensor was successfully created.'
        wants.html { redirect_to(admin_sensors_path) }
      else
        wants.html { render :action => "new" }
      end
    end
  end
  
  
  def destroy
    @sensor = Sensor.find(params[:id])
    
    if @sensor.destroy
      respond_to do |format|
        format.html { 
          flash[:success] = 'Deleted sensor' 
          redirect_to admin_sensors_path
        }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:success] = 'Unable to delete sensor' 
          redirect_to admin_sensors_path
        }
      end
    end
  end
end
