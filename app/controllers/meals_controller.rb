class MealsController < ApplicationController
  before_filter :set_user, :only => [:index, :week_view]

  def index
    # Prepare an array of meals
    @meals = Meal.all
    @meals = @user.meals if @user

    # Handle paginations
    if query_params[:page]
      @meals = @meals.page(query_params[:page])
      @meals = @meals.per(query_params[:per_page]) if query_params[:per_page]
    elsif query_params[:per_page]
      @meals = @meals.page(1).per(query_params[:per_page])
    else
      @meals = @meals.page(1).per(50)
    end

    @page = query_params[:page] || 1
    @per_page = query_params[:per_page] || 50

    @meals = @meals.order(:created_at => :desc)

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

  def query_params
    params.permit(:page, :per_page)
  end

end
