class Meal
  attr_accessor :created_at, :meal_records

  def initialize(params={})
    self.created_at = params[:created_at] || nil
    self.meal_records = params[:meal_records] || []
  end

  def carbs_estimate
    total_carbs = (0..0)

    self.meal_records.each do |meal_record|
      total_carbs += meal_record.total_carbs_estimate_to_range if meal_record.carbs_estimate.present?
    end

    return total_carbs
  end
end

class MealsController < ApplicationController
  before_filter :set_user, :only => :index

  def index
    # Prepare an array of meals
    @meals = [] # [Meal]

    meal_records = MealRecord.all
    meal_records = @user.meal_records if @user
    meal_records = meal_records.order(:created_at => :desc)

    # For each +1 meal records
    meal_records.each_with_index do |meal_record, index|
      if index > 0
        previous_meal_record = meal_records[index - 1]

        # if the creation date is within an hour after the creation date of the previous meal
        if (meal_record.created_at - previous_meal_record.created_at).abs <= 45.minutes
          # add it to the same group of the previous meal
          meal = @meals.last
          meal.meal_records.push meal_record

          meal.created_at = meal_record.created_at if meal_record.created_at < meal.created_at
        else
          # create a new group
          meal = Meal.new(
            :created_at => meal_record.created_at,
            :meal_records => [meal_record]
          )

          @meals.push meal
        end
      else
        # Initialize the first Meal!
        meal = Meal.new(
          :created_at => meal_record.created_at,
          :meal_records => [meal_record]
        )

        @meals.push meal
      end
    end
    
  end

  private

  def set_user
    @user = User.find_by_device_uuid(params[:user_id]) || User.find_by_id(params[:user_id]) if params[:user_id]
  end
end
