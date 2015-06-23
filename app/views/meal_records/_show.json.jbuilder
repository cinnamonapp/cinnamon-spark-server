
if meal_record
  json.extract! meal_record, :id, :title, :size, :serving, :carbs_estimate, :carbs_estimate_grams


  json.created_at gmt_date_to_user_date(meal_record.created_at, meal_record.user)
  json.updated_at gmt_date_to_user_date(meal_record.updated_at, meal_record.user)

  json.photo_original_url asset_url(meal_record.photo.url(:original))
  json.photo_blurred_background_url asset_url(meal_record.photo.url(:blurred_background))
  json.photo_thumb_url asset_url(meal_record.photo.url(:thumbnail))

  json.likes_count number_of_likes(meal_record)
  json.comments_count number_of_comments(meal_record)
  if params[:requesting_user_id].present?
    json.status (meal_record.carbs_estimate_grams..meal_record.carbs_estimate_grams).compare_to(User.find_by_identifier(params[:requesting_user_id]).daily_carbs_need_range)
    json.has_been_liked_by_user has_been_liked(meal_record, User.find_by_identifier(params[:requesting_user_id]))
  end

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
