class MealRecord < ActiveRecord::Base

  SIZES = ["1/2 cup", "1 cup", "2 cup"]
  CARBS_ESTIMATE = ["Low", "Medium", "High"]

  paginates_per 10

  has_attached_file :photo, styles: {
    thumbnail: "100x100>",
    medium: "300x300>",
    large: "800x800>"
  }

  belongs_to :user

  def carbs_estimate_to_range
    range = nil
    if self.carbs_estimate == 1
      range = 0..15
    end
    if self.carbs_estimate == 2
      range = 15..25
    end
    if self.carbs_estimate == 3
      range = 25..50
    end

    return range
  end

  def total_carbs_estimate_to_range
    self.carbs_estimate_to_range * self.real_size
  end

  def real_size
    if self.size == 1
      return 0.5
    end
    if self.size == 2
      return 1
    end
    if self.size == 3
      return 2
    end
  end

end
