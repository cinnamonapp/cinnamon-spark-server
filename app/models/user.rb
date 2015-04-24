class User < ActiveRecord::Base
  has_many :meal_records

  has_attached_file :profile_picture, styles: {
    nano: "20x20>",
    micro: "48x48>",
    thumbnail: "100x100>",
    medium: "300x300>",
    large: "800x800>"
  }

  def send_push_notification(message, options={})
    if self.push_notification_token.present? && message.present?
      notification = Houston::Notification.new(device: self.push_notification_token)
      notification.alert = message

      notification.sound = "sosumi.aiff"
      notification.content_available = true if options[:content_available]
      notification.custom_data = options[:custom_data] if options[:custom_data]

      CinnamonSparkServer::Application::APN.push notification
    else
      # raise "There is no push notification token for user (id=#{self.id})"
    end
  end


  def meal_records_count
    self.meal_records.count
  end
end
