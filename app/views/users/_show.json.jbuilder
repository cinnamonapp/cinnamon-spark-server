if user
  json.id user.id.to_s
  json.username user.username.to_s
  json.device_uuid user.device_uuid
  json.profile_picture_nano_url asset_url(user.profile_picture.url(:nano))
  json.profile_picture_micro_url asset_url(user.profile_picture.url(:micro))
  json.profile_picture_thumbnail_url asset_url(user.profile_picture.url(:thumbnail))
  json.meal_records_count user.meal_records_count
  json.daily_carbs_limit user.daily_carbs_need
else
  json.nil!
end
