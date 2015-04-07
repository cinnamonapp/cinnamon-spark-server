class AddUsernameAndProfilePictureToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_attachment :users, :profile_picture
  end
end
