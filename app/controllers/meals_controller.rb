class Meal
  attr_accessor :created_at, :meal_records

  def initialize(params={})
    self.created_at = params[:created_at] || nil
    self.meal_records = params[:meal_records] || []
  end

  def carbs_estimate
    total_carbs = (1..1)

    self.meal_records.each do |meal_record|
      total_carbs += meal_record.total_carbs_estimate_to_range if meal_record.carbs_estimate.present?
    end

    return total_carbs
  end

  def carbs_estimate_grams
    total_carbs = 0

    self.meal_records.each do |meal_record|
      total_carbs += meal_record.carbs_estimate_grams
    end

    return total_carbs
  end
end

class MealsController < ApplicationController
  before_filter :set_user, :only => [:index, :week_view]

  def index
    # Prepare an array of meals
    @meals = [] # [Meal]

    meal_records = MealRecord.all
    meal_records = @user.meal_records if @user
    meal_records = meal_records.order(:created_at => :desc)

    @meal_records = meal_records

    # For each +1 meal records
    meal_records.each_with_index do |meal_record, index|
      if index > 0
        previous_meal_record = meal_records[index - 1]

        # if the creation date is within 45 minutes after the creation date of the previous meal
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

  # Highly experimental code ==========
  # Heavily based on code that resides in lib/extras/week_day.rb

  def week_view

    @week_days = WeekDay.generate_week_days

    meal_records = MealRecord.all
    meal_records = @user.meal_records if @user

    # For each week_day
    @week_days.each do |week_day|

      # Generate time_frames
      time_frames = MealRecordsTimeFrame.generate_default_time_frames_without_time_zone
      # Add them to the week_day
      week_day.time_frames = time_frames

      # For each time_frame
      week_day.time_frames.each do |time_frame|
        date_time_frame = time_frame.to_time_frame_with_date(week_day.date)

        # Get meal_records for the current combo of week_day and time_frame with a query
        # Add meal_records to the current time_frame
        time_frame.meal_records = meal_records.where("meal_records.created_at BETWEEN '#{date_time_frame.first}' AND '#{date_time_frame.last}'")

        # raise if week_day.date.saturday?
      end

    end

  end

  private

  def set_user
    @user = User.find_by_device_uuid(params[:user_id]) || User.find_by_id(params[:user_id]) if params[:user_id]
  end
end
