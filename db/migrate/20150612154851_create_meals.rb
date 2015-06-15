class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.integer :carbs_estimate_grams
      t.integer :user_id

      t.timestamps
    end
  end
end
