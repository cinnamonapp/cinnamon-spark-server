class User < ActiveRecord::Base
  has_many :meal_records

  has_attached_file :profile_picture, styles: {
    nano: "20x20>",
    micro: "48x48>",
    thumbnail: "100x100>",
    medium: "300x300>",
    large: "800x800>"
  }

end
