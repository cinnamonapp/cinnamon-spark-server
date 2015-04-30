class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string  :name
      t.integer :carbs_per_cup
      t.integer :fat_secret_food_id

      t.timestamps
    end
  end
end
