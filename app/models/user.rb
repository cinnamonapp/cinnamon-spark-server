class User < ActiveRecord::Base
  has_many :meals
  has_many :meal_records
  has_many :likes
  has_many :comments

  has_attached_file :profile_picture, styles: {
    nano: "20x20>",
    micro: "48x48>",
    thumbnail: "100x100>",
    medium: "300x300>",
    large: "800x800>"
  }

  def self.find_by_identifier(identifier)
    User.find_by_device_uuid(identifier) || User.find_by_id(identifier)
  end

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

  def current_time
    time = DateTime.now.utc
    zone = (self.time_zone) ? self.time_zone.to_i : 2

    time += zone.hours

    return time
  end

  def meal_records_count
    self.meal_records.count
  end


  # Carbs needs
  def upper_daily_carbs_need
    self.daily_carbs_need
  end

  def lower_daily_carbs_need
    calculate_lower_need_with_upper_need(upper_daily_carbs_need)
  end

  def upper_daily_carbs_need_per_meal
    upper_daily_carbs_need / 3
  end

  def lower_daily_carbs_need_per_meal
    lower_daily_carbs_need / 3
  end

  def daily_carbs_need_per_meal_range
    (lower_daily_carbs_need_per_meal..upper_daily_carbs_need_per_meal)
  end


  private
  def calculate_lower_need_with_upper_need(carb_need)
    carb_need - 50
  end
end
