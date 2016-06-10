class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def gina_id
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "GINA::ID")
    else
      flash[:error] = "Unable to create account, #{@user.errors.full_messages.join(', ')} login using GINA::ID"
      redirect_to new_user_session_url
    end
  end

  def developer
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Developer")
    else
      session['devise.developer_data'] = request.env['omniauth.auth']
      redirect_to user_omniauth_authorize_path(:developer)
    end
  end

  def failure
    redirect_to root_path
  end
end