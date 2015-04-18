class MealRecord < ActiveRecord::Base

  SIZES = ["1/2 cup", "1 cup", "2 cup"]
  CARBS_ESTIMATE = ["Low", "Medium", "High"]

  has_attached_file :photo, styles: {
    thumbnail: "100x100>",
    medium: "300x300>",
    large: "800x800>"
  }

  belongs_to :user
end
