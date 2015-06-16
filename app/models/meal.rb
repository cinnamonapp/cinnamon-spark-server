class Meal < ActiveRecord::Base
  TIME_SPAN_BETWEEN_MEAL_RECORDS = 45.minutes

  before_save :self_update #, :update_created_at

  belongs_to :user
  has_many :meal_records

  def self.most_recent
    order(:created_at => :desc).first
  end

  def self.assign_to_last_or_create_by_meal_record(meal_record, user=meal_record.user)
    should_push_meal_record = false

    last_meal = user.meals.most_recent

    # There is at least a meal
    if last_meal.present?
      last_meal_record = last_meal.meal_records.most_recent
      puts "Last Meal is there => #{last_meal.id}"

      # There is at least a meal record associated to the meal
      if last_meal_record.present?
        puts "Last Meal Record is there"
        puts "#{meal_record.created_at} - #{last_meal_record.created_at} <= #{TIME_SPAN_BETWEEN_MEAL_RECORDS} "
        if meal_record.created_at - last_meal_record.created_at <= TIME_SPAN_BETWEEN_MEAL_RECORDS
          puts "Push it"
          should_push_meal_record = true
        end
      # Attach meal_record to last_meal
      else
        should_push_meal_record = true
      end

    end

    # If it is eligible for this meal
    if should_push_meal_record
      puts "Pushing it into last meal"
      last_meal.meal_records.push meal_record
    else
      puts "Creating last meal"
      last_meal = Meal.new(
        user: user,
        meal_records: MealRecord.where(:id => meal_record.id)
      )
    end
    if last_meal.save
      puts "Successfully saved"
    else
      puts "Errors in saving meal => #{last_meal.errors}"
    end

    last_meal

  end

  def self_update
    update_carbs_estimate_grams

    return true
  end

  private
  def update_carbs_estimate_grams
    total_carbs = 0

    self.meal_records.each do |meal_record|
      total_carbs += meal_record.carbs_estimate_grams
    end

    self.carbs_estimate_grams = total_carbs
  end

  # def update_created_at
  #   puts "Meal => Updating created at with meal_records#{self.meal_records.count}"
  #   if self.meal_records.count > 0
  #     self.created_at = meal_records.least_recent.created_at
  #   end
  # end
end
