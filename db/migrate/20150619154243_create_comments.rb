class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :meal_record_id
      t.integer :user_id
      t.text :message

      t.timestamps
    end
  end
end
