json.meals do
  json.array! @meals do |meal|
    json.created_at   meal.created_at + @user.time_zone.to_i.hours
    json.carbs_estimate_grams meal.carbs_estimate_grams
    json.status (meal.carbs_estimate_grams..meal.carbs_estimate_grams).compare_to(@user.daily_carbs_need_per_meal_range)
    json.user do
      json.partial! "users/show", user: @user
    end
    json.meal_records meal.meal_records.sort{|a, b| b.size <=> a.size}, partial: "meal_records/show", as: :meal_record, hide_user: true
  end
end
