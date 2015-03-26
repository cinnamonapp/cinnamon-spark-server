class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :device_uuid

      t.timestamps
    end
  end
end
