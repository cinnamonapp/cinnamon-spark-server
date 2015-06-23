class Ingredient < ActiveRecord::Base

  has_many :meal_record_ingredients
  has_many :meal_records, through: :meal_record_ingredients

  # New ingredient with food id
  def self.new_with_fat_secret_food_id(food_id)
    food = FatSecret.carbs_per_cup_food(food_id)["food"]

    ingredient = Ingredient.new()
    ingredient.name = food["food_name"]
    ingredient.fat_secret_food_id = food["food_id"]
    ingredient.carbs_per_cup = food["carbohydrate"]

    ingredient
  end
end
