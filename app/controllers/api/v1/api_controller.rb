class Api::V1::ApiController < ApplicationController
  respond_to :json
  before_filter :verify_user

  def verify_user
    #TODO: I changed the .where().first to find_by().
    @user = User.find_by(authentication_token: params[:authentication_token])
    if @user.nil?
      render json: { errors: "User must be logged in" }, success: false, status: 420
    end
  end
end
