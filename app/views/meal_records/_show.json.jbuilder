json.extract! meal_record, :id, :title, :size, :carbs_estimate, :created_at, :updated_at
json.carbs_estimate_grams meal_record.carbs_estimate_grams
json.photo_original_url asset_url(meal_record.photo.url)
json.photo_thumb_url asset_url(meal_record.photo.url(:thumbnail))

if meal_record.user.present?
  json.user do
    json.id meal_record.user.id.to_s
    json.username meal_record.user.username.to_s
    json.profile_picture_nano_url asset_url(meal_record.user.profile_picture.url(:nano))
    json.profile_picture_micro_url asset_url(meal_record.user.profile_picture.url(:micro))
    json.profile_picture_thumbnail_url asset_url(meal_record.user.profile_picture.url(:thumbnail))
  end
end
