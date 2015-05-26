json.dashboard do
  json.daily_carbs_limit      @daily_carbs_need
  json.daily_used_carbs       @day_used_carbs
  json.daily_remaining_carbs  @remaining_carbs
  json.current_status_at_time carbs_compare(@user.current_time.hour, @day_used_carbs, @daily_carbs_need)

  json.smart_alert_message @smart_alert
  json.background_image (@background_image) ? asset_url(@background_image) : nil

  json.last_meal_record do
    json.partial! 'meal_records/show', meal_record: @last_meal_record
  end

  # The user
  json.user do
    json.partial! 'users/show', user: @user
  end

  # The current week streak
  json.current_streak @current_streak do |streak_day|
    json.date               streak_day[:date]
    json.daily_carbs_limit  streak_day[:daily_carbs_limit]
    json.daily_used_carbs   streak_day[:daily_used_carbs]
    json.status             carbs_compare(total_hours(), streak_day[:daily_used_carbs], streak_day[:daily_carbs_limit])
    json.meal_records_count streak_day[:meal_records_count]

    json.last_meal_record do
      json.partial! 'meal_records/show', meal_record: streak_day[:last_meal_record]
    end
  end
end
