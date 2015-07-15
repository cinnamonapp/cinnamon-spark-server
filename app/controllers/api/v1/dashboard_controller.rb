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

    message = "Good morning, sunshine! How about breakfast to fuel your day?"

    status = carbs_compare(houroftheday, @day_used_carbs, @daily_carbs_need)
# raise
    # breakfast 1 - 11
    if houroftheday < 12
      case status
      when -1
        message = "You can do better than that. Healthy carbs are calling your name!"
      when 0
        message = "Well done, my friend. You're off to a great start."
      when 1
        message = "Don't spend all your carbs in one sitting. Balance is the key."
      end
    # lunch 12 - 16
    elsif houroftheday < 17
      case status
      when -1
        message = "Think you can slip that carbless meal past me? Think again."
      when 0
        message = "Well, look who's mastering healthy eating! Looks like I'm useful after all."
      when 1
        message = "Got a little carried away? Plan for a light dinner, and we'll pretend it never happened."
      end
    # Dinner 17 - 24
    else
      case status
      when -1
        message = "You're so low on carbs even I'm losing energy. Come on - help me, help you."
      when 0
        message = "Someone sure knows their carbs. Great work! But there goes my job security."
      when 1
        message = "Let that be our little treat. Treats are good, but so is tomorrow for a fresh start."
      end
    end

    if meal_records.empty?
      message = "Your daily goal is #{@daily_carbs_need}g.\nTake a picture and get started."
    end

    message
  end
end
