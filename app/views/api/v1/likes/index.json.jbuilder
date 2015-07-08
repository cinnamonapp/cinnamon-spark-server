json.likes @likes do |like|
  json.extract! like, :id, :user_id, :meal_record_id, :created_at
  if like.user.present?
    json.user do
      json.partial! 'users/show', user: like.user
    end
  end

  if like.meal_record.present?
    json.meal_record do
      json.partial! 'meal_records/show', meal_record: like.meal_record, hide_user: true
    end
  end

end
