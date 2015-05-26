class Api::V1::DashboardController < Api::V1::BaseController
  before_filter :set_user

  # The default action
  def index
    @default_grams_limit  = 250

    @daily_carbs_need = @user.daily_carbs_need || @default_grams_limit
    @day_used_carbs =  0
    @remaining_carbs      =  0

    @last_meal_record = nil
    @background_image = nil

    # take the current user day
    # retreive user's meal records at day
    # sum carbs
    date = @user.current_time
    meal_records = @user.meal_records.created_at_date(date)

    meal_records.each do |meal_record|
      @day_used_carbs += meal_record.carbs_estimate_grams
    end
    @remaining_carbs = @daily_carbs_need - @day_used_carbs

    @last_meal_record = meal_records.most_recent

    random_meal_record = MealRecord.all.sample

    @background_image = (@last_meal_record.present?) ? @last_meal_record.photo.url(:blurred_background) : random_meal_record.photo.url(:blurred_background) || random_meal_record.photo.url(:original)

    @current_streak = current_streak
    @smart_alert = smart_alert
  end


  private

  def set_user
    @user = User.find_by_device_uuid(params[:user_id]) || User.find_by_id(params[:user_id])
  end

  def current_streak
    streak = []

    today = @user.current_time.to_date
    aweekago = today - 6.days

    current_week = aweekago..today

    current_week.each do |day|
      meal_records = @user.meal_records.created_at_date(day)

      carbs_used = 0
      meal_records.each do |meal_record|
        carbs_used += meal_record.carbs_estimate_grams
      end

      streak << {
        date: day,
        daily_carbs_limit: @daily_carbs_need,
        daily_used_carbs: carbs_used,
        meal_records_count: meal_records.count,
        last_meal_record: meal_records.most_recent
      }
    end

    streak
  end

  def smart_alert
    date = @user.current_time
    meal_records = @user.meal_records.created_at_date(date)

    message = "Doing a great job as always my friend."

    if meal_records.empty?
      message = "Your daily goal is #{@daily_carbs_need}g.\nTake a picture and get started."
    end

    message
  end
end
