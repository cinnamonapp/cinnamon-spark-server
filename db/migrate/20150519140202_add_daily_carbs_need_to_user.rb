class AddDailyCarbsNeedToUser < ActiveRecord::Migration
  def change
    add_column :users, :daily_carbs_need, :integer, default: 200
  end
end
