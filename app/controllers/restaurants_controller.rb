class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @user = current_user
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.create(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    unless @restaurant.created_by?(current_user)
      flash[:notice] = "You can only edit restaurants you have created."
      redirect_to restaurants_path
    end
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update_as_user(restaurant_params, current_user)
    redirect_to restaurants_path
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    unless @restaurant.destroy_as_user(current_user)
      flash[:notice] = "You can only delete restaurants you have created."
    else
      flash[:notice] = 'Restaurant deleted successfully'
    end
    redirect_to restaurants_path
  end

  def is_creator?(created_item)
    current_user.id == created_item.user_id
  end
end
