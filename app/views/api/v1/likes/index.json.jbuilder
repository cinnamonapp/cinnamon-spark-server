json.likes @likes do |like|
  json.extract! like, :id, :user_id, :meal_record_id, :created_at
  if like.user.present?
    json.user do
      json.partial! 'users/show', user: like.user
    end
  end

end
