class Users::SessionsController < Devise::SessionsController

	skip_before_action :require_user,only:[:new,:create]
	skip_before_action :set_current_user_tenant,only:[:new,:create]


  # GET /resource/sign_in
  # def new
  #   p params
  #   puts '----------------------------------------------'
  #   super
  # end

  # POST /resource/sign_in
  def create
    p params
    puts '---------------------------------2-------------'
    # super

    params[:user] = params[:user_session] if params[:user_session]
    resource = User.find_for_database_authentication(:email => params[:user][:email])
    return invalid_login_attempt unless resource
    if resource.valid_password?(params[:user][:password])
      sign_in(resource_name, resource)
      render :json => {result: true,
                       content: I18n.t('auth.msg.login_success')}
      return
    end
    invalid_login_attempt

  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
