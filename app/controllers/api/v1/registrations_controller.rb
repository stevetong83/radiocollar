class Api::V1::RegistrationsController < Api::V1::ApiController
  skip_before_filter :verify_user


  ##
  # == POST /api/v1/register
  # Authenticate the user and return back authentication token if successful login
  # [Required POST VARS]
  #   email::
  #   password::
  # === Success
  # [200] OK
  # === Failure
  # [422] 
  
  def create
    user = User.new(email: params[:email], password: params[:password])

    if user.save
      render json: {authentication_token: user.authentication_token}, success: true, status: :ok
    else
      warden.custom_failure!
      render json: user.errors, success: false, status: 422
    end
  end

  ##
  # == POST /api/v1/reset_password
  # Check for existing user and send reset password email if valid
  # [Required POST VARS]
  #   email::
  # === Success
  # [200] OK
  # === Failure
  # [422] 
  #   message: No such email

  def reset_password
    user = User.find_for_database_authentication(email: params[:email])

    if user.present?
      user.send_reset_password_instructions
      # render json: success: true, status: :ok
    else
      render json: {message: "No such email"}, success: false, status: 422
    end

  end

end