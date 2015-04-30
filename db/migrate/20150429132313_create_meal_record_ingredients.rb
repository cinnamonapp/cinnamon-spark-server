class CreateMealRecordIngredients < ActiveRecord::Migration
  def change
    create_table :meal_record_ingredients do |t|
      t.integer :meal_record_id
      t.integer :ingredient_id
      t.integer :percentage_in_meal_record

      t.timestamps
    end
  end
end
