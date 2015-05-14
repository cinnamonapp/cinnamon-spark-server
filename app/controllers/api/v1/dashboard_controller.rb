class Api::V1::DashboardController < Api::V1::BaseController
  before_filter :set_user

  # The default action
  def index
    @default_grams_limit  = 150
    @day_used_carbs =  0
    @remaining_carbs      =  0

    @last_meal_record = nil
    @background_image = nil

    # take the current user day
    # retreive user's meal records at day
    # sum carbs
    date = @user.current_time
    meal_records = @user.meal_records.created_at_date(date)

    meal_records.each do |meal_record|
      @day_used_carbs += meal_record.carbs_estimate_grams
    end
    @remaining_carbs = @default_grams_limit - @day_used_carbs

    @last_meal_record = meal_records.most_recent

    random_meal_record = MealRecord.all.sample

    @background_image = (@last_meal_record.present?) ? @last_meal_record.photo.url(:blurred_background) : random_meal_record.photo.url(:blurred_background) || random_meal_record.photo.url(:original)
  end


  private

  def set_user
    @user = User.find_by_device_uuid(params[:user_id]) || User.find_by_id(params[:user_id])
  end

end
