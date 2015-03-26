json.extract! meal_record, :id, :size, :carbs_estimate, :created_at, :updated_at
json.photo_original_url asset_url(meal_record.photo.url)
json.photo_thumb_url asset_url(meal_record.photo.url(:thumbnail))
