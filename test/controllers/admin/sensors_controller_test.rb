require 'test_helper'

class Admin::SensorsControllerTest < ActionController::TestCase
  def setup
    login_user(:admin)

    @sensor = sensors(:dnb)
  end

  test 'it renders index' do
    get :index

    assert_response :success
  end

  test 'it renders edit' do
    get :edit, id: @sensor

    assert_response :success
  end

  test 'it updates the sensor' do
    patch :update, id: @sensor, sensor: {
      name: "updated-sensor",
      selected_by_default: false
    }

    assert_response :redirect
  end

  test 'it renders new' do
    get :new

    assert_response :success
  end

  test 'it creates a new sensor' do
    assert_difference('Sensor.count') do
      post :create, sensor: {
        name: 'new-sensor',
        selected_by_default: false
      }
    end

    assert_response :redirect
  end

  test 'it destroys a sensor' do
    assert_difference('Sensor.count', -1) do
      post :destroy, id: @sensor
    end

    assert_response :redirect
  end
end