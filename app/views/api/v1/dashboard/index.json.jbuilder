json.dashboard do
  json.daily_carbs_limit      @default_grams_limit
  json.daily_used_carbs       @day_used_carbs
  json.daily_remaining_carbs  @remaining_carbs

  json.background_image (@background_image) ? asset_url(@background_image) : nil

  json.last_meal_record do
    json.partial! 'meal_records/show', meal_record: @last_meal_record
  end

  json.user do
    json.partial! 'users/show', user: @user
  end

  json.current_streak @current_streak
  json.smart_alert_message @smart_alert
end
