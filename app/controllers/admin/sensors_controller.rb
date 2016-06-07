class Admin::SensorsController < AdminController
  authorize_resource

  def index
    @sensors = Sensor.all
  end

  def edit
    @sensor = Sensor.find(params[:id])
  end

  def update
    @sensor = Sensor.find(params[:id])

    respond_to do |format|
      if @sensor.update_attributes(sensor_params)
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
    @sensor = Sensor.new(sensor_params)

    respond_to do |format|
      if @sensor.save
        flash[:notice] = 'Sensor was successfully created.'
        format.html { redirect_to(admin_sensors_path) }
      else
        format.html { render :action => "new" }
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
  private

  def sensor_params
    params.require(:sensor).permit(:name, :selected_by_default)
  end
end
