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

  has_many :meal_record_ingredients
  has_many :ingredients, through: :meal_record_ingredients

  def carbs_estimate_v2
    size_coeff = 1

    if self.size == 1
      size_coeff = 0.5
    end

    if self.size == 3
      size_coeff = 2
    end

    carbs_sum = 0

    self.meal_record_ingredients.each do |meal_record_ingredient|
      ingredient = meal_record_ingredient.ingredient
      carbs_per_cup = ingredient.carbs_per_cup || 0
      percentage = meal_record_ingredient.percentage_in_meal_record / 100.0

      carbs_sum += carbs_per_cup * percentage
    end
    return (carbs_sum * size_coeff).to_i

  end

  def fat_secret_ingredients=(fs_ingredients)
    # Clear meal_record_ingredients
    self.meal_record_ingredients.delete_all

    fs_ingredients.each do |fs_ingredient|
      ingredient = Ingredient.new_with_fat_secret_food_id(fs_ingredient["food_id"])
      meal_record_ingredient = self.meal_record_ingredients.new(percentage_in_meal_record: fs_ingredient["percentage_in_meal_record"])
      meal_record_ingredient.ingredient = ingredient
    end
  end

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
