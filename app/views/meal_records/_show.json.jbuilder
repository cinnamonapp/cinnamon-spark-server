if meal_record
  json.extract! meal_record, :id, :title, :size, :serving, :carbs_estimate, :carbs_estimate_grams, :created_at, :updated_at
  json.photo_original_url asset_url(meal_record.photo.url(:original))
  json.photo_blurred_background_url asset_url(meal_record.photo.url(:blurred_background))
  json.photo_thumb_url asset_url(meal_record.photo.url(:thumbnail))

  if meal_record.user.present?
    json.user do
      json.partial! 'users/show', user: meal_record.user
    end
  end
else
  json.nil!
end
