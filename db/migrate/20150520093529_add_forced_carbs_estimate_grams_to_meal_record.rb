class AddForcedCarbsEstimateGramsToMealRecord < ActiveRecord::Migration
  def change
    add_column :meal_records, :forced_carbs_estimate_grams, :integer
  end
end
