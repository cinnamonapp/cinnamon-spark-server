json.meals do
  json.array! @meals do |meal|
    json.created_at  @user.to_user_time_zone_with_date(meal.created_at)
    json.carbs_estimate_grams meal.carbs_estimate_grams
    json.status (meal.carbs_estimate_grams..meal.carbs_estimate_grams).compare_to(@user.daily_carbs_need_per_meal_range)
    json.user do
      json.partial! "users/show", user: @user
    end
    json.meal_records meal.meal_records.order(:size => :desc), partial: "meal_records/show", as: :meal_record, hide_user: true
  end
end
json.page @page
json.per_page @per_page
