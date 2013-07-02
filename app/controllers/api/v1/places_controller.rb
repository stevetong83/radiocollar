class Api::V1::PlacesController < Api::V1::ApiController

  def index
    places = @user.places.all
    render json: places.to_json
  end

  ##
  # == POST /api/v1/places
  # Authenticate the user and save location
  # [Required POST VARS]
  #   authentication_token::
  #   name::
  #   lat::
  #   long::
  # === Success
  # [200] OK
  # === Failure
  # [420] User must be logged in
  # [422] Invalid params

  def create
    url = Place.set_map_url(params[:name], params[:lat], params[:lat])
    @place = @user.places.build(name: params[:name], lat: params[:lat], long: params[:long], location_url: url)
    if @place.save
      render json: @place.to_json, success: true, status: 200
    else
      render json: @place.errors, success: false, status: 422
    end
  end

  ##
  # == POST /api/v1/places/:id
  # Authenticate the user and save location
  def show
    @place = Place.find params[:id]
    render json: @place.to_json
  end

  ##
  # == DELETE /api/v1/places/:id
  # Authenticate the user and save location
  def destroy
    @place = Place.find params[:id]
    @place.destroy
    render json: {message: "Place has been deleted"}, success: true, status: 200
  end
end
