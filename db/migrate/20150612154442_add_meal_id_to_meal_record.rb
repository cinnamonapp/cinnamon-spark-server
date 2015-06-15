class AddMealIdToMealRecord < ActiveRecord::Migration
  def change
    add_column :meal_records, :meal_id, :integer
  end
end
