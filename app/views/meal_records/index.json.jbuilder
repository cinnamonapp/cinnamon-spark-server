json.array!(@meal_records) do |meal_record|
  json.extract! meal_record, :id, :size, :carbs_estimate, :photo
  json.url meal_record_url(meal_record, format: :json)
end
