class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :meal_record_id

      t.timestamps
    end
  end
end
