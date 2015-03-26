json.array!(@users) do |user|
  json.extract! user, :id, :device_uuid
  json.url user_url(user, format: :json)
end
