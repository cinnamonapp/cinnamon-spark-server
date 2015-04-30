class MealRecordIngredient < ActiveRecord::Base
  belongs_to :meal_record
  belongs_to :ingredient
end
