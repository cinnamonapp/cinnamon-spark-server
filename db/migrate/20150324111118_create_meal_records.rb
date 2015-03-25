class CreateMealRecords < ActiveRecord::Migration
  def change
    create_table :meal_records do |t|
      t.integer :size
      t.integer :carbs_estimate
      t.integer :user_id
      t.attachment :photo

      t.timestamps
    end
  end
end
