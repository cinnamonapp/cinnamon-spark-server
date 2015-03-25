class MealRecord < ActiveRecord::Base
  has_attached_file :photo, styles: {
    thumbnail: "100x100>",
    medium: "300x300>",
    large: "800x800>"
  }
end
