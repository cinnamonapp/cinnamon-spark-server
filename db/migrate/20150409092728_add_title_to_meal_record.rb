class AddTitleToMealRecord < ActiveRecord::Migration
  def change
    add_column :meal_records, :title, :string
  end
end
