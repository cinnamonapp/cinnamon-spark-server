
if meal_record
  json.extract! meal_record, :id, :title, :size, :serving, :carbs_estimate, :carbs_estimate_grams
  json.created_at meal_record.user.to_user_time_zone_with_date(meal_record.created_at)
  json.updated_at meal_record.user.to_user_time_zone_with_date(meal_record.updated_at)
  json.photo_original_url asset_url(meal_record.photo.url(:original))
  json.photo_blurred_background_url asset_url(meal_record.photo.url(:blurred_background))
  json.photo_thumb_url asset_url(meal_record.photo.url(:thumbnail))

  if meal_record.user.present?
    unless defined?(hide_user) && hide_user
      json.user do
        json.partial! 'users/show', user: meal_record.user
      end
    end
  end
else
  json.nil!
end
