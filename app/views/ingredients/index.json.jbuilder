json.array!(@ingredients) do |ingredient|
  json.extract! ingredient, :id, :name, :carbs_per_cup
  json.url ingredient_url(ingredient, format: :json)
end
