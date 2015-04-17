class AddPushNotificationTokenAndDeviceTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :push_notification_token, :text
    add_column :users, :device_type, :string
  end
end
