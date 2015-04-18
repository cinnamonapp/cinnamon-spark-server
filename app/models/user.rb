class User < ActiveRecord::Base
  has_many :meal_records

  has_attached_file :profile_picture, styles: {
    nano: "20x20>",
    micro: "48x48>",
    thumbnail: "100x100>",
    medium: "300x300>",
    large: "800x800>"
  }

  def send_push_notification(message="")
    if self.push_notification_token.present?
      notification = Houston::Notification.new(device: self.push_notification_token)
      notification.alert = message
      # Add a sound
      notification.sound = "sosumi.aiff"

      CinnamonSparkServer::Application::APN.push notification
    else
      # raise "There is no push notification token for user (id=#{self.id})"
    end
  end

end
