class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_filter :verify_user, only: :create
  ##
  # == POST /api/v1/login
  # Authenticate the user and return back authentication token if successful login
  # [Required POST VARS]
  #   email::
  #   password::
  # === Success
  # [200] OK
  # === Failure
  # [401] Invalid Email or Password

  def create
    #ex: curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"email":"rick.carlino@gmail.com","password":"testaccount"}'  http://localhost:3000/api/v1/sessions

    user = User.find_for_database_authentication(email: params[:email])
 
    if user && user.valid_password?(params[:password])
      user.ensure_authentication_token!  # make sure the user has a token generated
      # render :inline => "#{params[:callback]}('hi')"
      render json: { authentication_token: user.authentication_token }, success: true, status: :ok
    else
      return invalid_login_attempt
    end
  end
 
  ##
  # == Delete /api/v1/logout
  # Reset authentication token
  # [Required POST VARS]
  #   authentication_token::
  # === Success
  # [200] OK
  # [JSON body]
  #   message: Session deleted

  def destroy
    @user.reset_authentication_token!
    render json: { message: "Logged out successfully" },  success: true, status: :ok
  end
 
  private
 
  def invalid_login_attempt
    warden.custom_failure!
    render json: { errors: "Invalid email or password." },  success: false, status: :unauthorized
  end

end