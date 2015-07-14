# Foods
class Api::V1::FatSecret::FoodsController < Api::V1::FatSecret::BaseController

  before_filter :set_food, only: [:show]

  def index
    @foods = FatSecret.search_food(query_params[:query], 0, 20)
  end

  def show

  end

  def carbs_per_cup
    @food = FatSecret.carbs_per_cup_food(params[:id] || params[:food_id])["food"]
  end

  def carbs_per_servings
    @food = FatSecret.carbs_per_servings(params[:id] || params[:food_id])["food"]
  end

  private

  def set_food
    @food = FatSecret.food(params[:id]) if params[:id]
    @food = FatSecret.food(params[:food_id]) if params[:food_id]
    @food = @food["food"]
  end

  def query_params
    q_params = params.permit(:query)
  end
end
