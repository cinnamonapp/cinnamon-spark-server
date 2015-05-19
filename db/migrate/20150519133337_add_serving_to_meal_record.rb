class AddServingToMealRecord < ActiveRecord::Migration
  def change
    add_column :meal_records, :serving, :integer, default: 1
  end
end
