json.comments @comments do |comment|
  json.extract! comment, :message
  json.created_at gmt_date_to_user_date(comment.created_at, comment.user)
  json.user do
    json.partial! "users/show", user: comment.user
  end
  json.meal_record do
    json.partial! "meal_records/show", meal_record: comment.meal_record, hide_user: true
  end
end
