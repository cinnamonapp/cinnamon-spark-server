class MealRecord < ActiveRecord::Base

  # validate :photo_uniqueness

  validates :user,          presence: true
  validates :created_at,    uniqueness: {scope: :user_id}

  after_save :update_meal

  SIZES = ["0.5", "1", "1.5", "2"]
  SERVINGS = ["Cup", "Piece"]
  CARBS_ESTIMATE = ["Low", "Medium", "High"]

  paginates_per 10

  has_attached_file :photo, styles: {
    thumbnail: "100x100>",
    medium: "300x300>",
    large: "800x800>",
    blurred_background: {
      processors: [:blur]
    }
  }

  belongs_to :user
  belongs_to :meal

  has_many :likes
  has_many :comments

  has_many :meal_record_ingredients
  has_many :ingredients, through: :meal_record_ingredients


  scope :created_at_date, lambda{|date| where("DATE(meal_records.created_at) = DATE(?)", date)}

  scope :created_within, lambda{|interval| where("meal_records.created_at > ?", DateTime.now.utc - interval)}

  def self.most_recent
    order(:created_at => :desc).each.first
  end

  def self.least_recent
    order(:created_at => :asc).each.first
  end

  # Returns the grams of carbs in the meal_record based on its ingredients
  def carbs_estimate_grams

    return self.forced_carbs_estimate_grams if self.forced_carbs_estimate_grams.present?

    size_coeff = self.real_size

    carbs_sum = 0

    self.meal_record_ingredients.each do |meal_record_ingredient|
      ingredient = meal_record_ingredient.ingredient
      carbs_per_cup = ingredient.carbs_per_cup || 0
      percentage = meal_record_ingredient.percentage_in_meal_record / 100.0

      carbs_sum += carbs_per_cup * percentage
    end

    return (carbs_sum * size_coeff).to_i
  end

  # Set ingredients from fat_secret data
  def fat_secret_ingredients=(fs_ingredients)
    # Clear meal_record_ingredients
    self.meal_record_ingredients.delete_all

    fs_ingredients.each do |fs_ingredient|
      ingredient = Ingredient.new_with_fat_secret_food_id(fs_ingredient["food_id"])
      meal_record_ingredient = self.meal_record_ingredients.new(percentage_in_meal_record: fs_ingredient["percentage_in_meal_record"])
      meal_record_ingredient.ingredient = ingredient
    end
  end

  def carbs_estimate

    estimate_from_grams = nil
    grams = carbs_estimate_grams
    estimate_from_grams = 1 if grams < 30
    estimate_from_grams = 2 if grams >= 30 && grams <=50
    estimate_from_grams = 3 if grams > 50

    estimate_from_grams = nil if grams == 0

    self["carbs_estimate"] || estimate_from_grams
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
      return 1.5
    end
    if self.size == 4
      return 2
    end

    puts "MealRecord.rb#real_size => Size not implemented."
    return 1
  end

  private
  def update_meal
    if meal.present?
      meal.self_update
      meal.save
    end
  end

  # def photo_uniqueness
  #   if user.present?
  #     last_meal_record = user.meal_records.most_recent
  #     if last_meal_record.present?
  #       if id != last_meal_record.id && photo_file_size.present?
  #         if photo_file_size == last_meal_record.photo_file_size
  #           errors.add(:photo, "can't be duplicate")
  #         end
  #       end
  #     end
  #   end
  # end
end
