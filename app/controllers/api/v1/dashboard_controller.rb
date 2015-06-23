class Api::V1::DashboardController < Api::V1::BaseController
  include Api::V1::DashboardHelper

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
    datetime      = @user.current_time
    houroftheday  = datetime.hour
    meal_records  = @user.meal_records.created_at_date(datetime)

    message = "Good morning beauty. Let's start the day with some great breakfast. "

    status = carbs_compare(houroftheday, @day_used_carbs, @daily_carbs_need)
# raise
    # breakfast 1 - 11
    if houroftheday < 12
      case status
      when -1
        message = "Hey, you need carbs. Go and get a good breakfast!"
      when 0
        message = "Within range: well done my friend. You are doing great today."
      when 1
        message = "I hope it was delicious at least. Take it easy for the next meal though!"
      end
    # lunch 12 - 16
    elsif houroftheday < 17
      case status
      when -1
        message = "You need carbs to survive your day. So go and get them!"
      when 0
        message = "You are doing just great today. Within range: congratulations!"
      when 1
        message = "Take it easy my friend. Some light dinner will do good."
      end
    # Dinner 17 - 24
    else
      case status
      when -1
        message = "Get your carbs together my friend. Trust me you need them! Eat, eat, eat."
      when 0
        message = "You know your carbs well my friend. Have a good night, you did great today!"
      when 1
        message = "Let's call it a treat day. Good that tomorrow is another day!"
      end
    end

    if meal_records.empty?
      message = "Your daily goal is #{@daily_carbs_need}g.\nTake a picture and get started."
    end

    message
  end
end
