class CampsController < ApplicationController
before_action :set_camp, only: [:show, :edit, :update, :destroy]
skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @camps = Camp.all
    @camps = Camp.where.not(latitude: nil, longitude: nil)
    @hash = Gmaps4rails.build_markers(@camps) do |camp, marker|
      marker.lat camp.latitude
      marker.lng camp.longitude
       marker.picture({
        :url => ActionController::Base.helpers.asset_path('marker.png'),
        :width   => 18.42,
        :height  => 70,
       })
      # marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    end
  end

  def show
    @booking = Booking.new
    @review = Review.new
    @hash = Gmaps4rails.build_markers(@camp) do |camp, marker|
      marker.lat camp.latitude
      marker.lng camp.longitude
       marker.picture({
        :url => ActionController::Base.helpers.asset_path('marker.png'),
        :width   => 18.42,
        :height  => 70,
       })
    end
  end


  def new
    @camp = Camp.new
  end

  def create
    @camp = Camp.new(camp_params)
    @camp.price = params[:camp][:price].match(/\d+/)
    @camp.user = current_user
    if @camp.save
      redirect_to my_camp_path(@camp)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @camp.update(camp_params)
    @camp.price = params[:camp][:price].match(/\d+/)
    if @camp.save
      redirect_to camp_path(@camp)
    else
      render :new
    end
  end

  def destroy
    @camp.destroy
    redirect_to camps_path
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def camp_params
    params.require(:camp).permit(:title, :description, :address, :photo, :photo_cache)
  end

  def set_camp
    @camp = Camp.find(params[:id])
  end

end
