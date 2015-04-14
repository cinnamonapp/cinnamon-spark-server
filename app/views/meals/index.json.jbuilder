json.array! @meals do |meal|
  json.extract! meal, :created_at
  json.meal_records meal.meal_records, partial: "meal_records/show", as: :meal_record
end
