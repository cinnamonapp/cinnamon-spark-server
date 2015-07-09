class MealRecordsController < ApplicationController
  before_action :set_meal_record, only: [:show, :edit, :update, :destroy]
  before_action :set_user

  # GET /meal_records
  # GET /meal_records.json
  def index
    if params[:user_id]
      @meal_records = @user.meal_records if @user
    # elsif params[:except_user_id]
    #   user = User.find_by_device_uuid(params[:except_user_id]) || User.find_by_id(params[:except_user_id])
    #   @meal_records = MealRecord.where("user_id != ?", user.id)

    # Assuming all meal records have associated users for now.
    else
      @meal_records = MealRecord.all
    end

    # Handle paginations
    if query_params[:page]
      @meal_records = @meal_records.page(query_params[:page])
      @meal_records = @meal_records.per(query_params[:per_page]) if query_params[:per_page]
    elsif query_params[:per_page]
      @meal_records = @meal_records.page(1).per(query_params[:per_page])
    end

    @meal_records = @meal_records.order(:created_at => :desc)

    respond_to do |format|
      format.json{}
      format.html{}
    end
  end

  # GET /meal_records/estimate
  PRIORITY_ESTIMATE_WITHIN_MINUTES = 60.minutes
  def estimate
    needs_estimation = MealRecord.where("meal_records.forced_carbs_estimate_grams IS NULL")
    needs_estimation = needs_estimation.order(created_at: :desc) # Most recent first

    # MealRecords that haven't received an estimation created within #{PRIORITY_ESTIMATE_WITHIN_MINUTES}
    @priority_list = needs_estimation.where("meal_records.created_at > ?", DateTime.now - PRIORITY_ESTIMATE_WITHIN_MINUTES)

    # MealRecords that simply need estimation
    @needs_estimation = needs_estimation.where("meal_records.created_at < ?", DateTime.now - PRIORITY_ESTIMATE_WITHIN_MINUTES)

    # Ids of MealRecords with associated ingredients
    with_ingredient_ids = MealRecord.includes(:meal_record_ingredients).where("meal_record_ingredients.id IS NOT NULL").map(&:id)
    does_not_need_estimation = MealRecord.where("meal_records.forced_carbs_estimate_grams IS NOT NULL")
    # MealRecords that needs only ingredients estimation
    @needs_ingredients_only = does_not_need_estimation.where("meal_records.id NOT IN (?)", with_ingredient_ids)

    # Redirect automatically to the most important estimation
    if params[:auto_select]
      next_meal_record = nil

      if @priority_list.any?
        next_meal_record = @priority_list.first
      elsif @needs_estimation.any?
        next_meal_record = @needs_estimation.first
      elsif @needs_ingredients_only.any?
        next_meal_record = @needs_ingredients_only.first
      end

      if next_meal_record.present?
        redirect_to edit_meal_record_url(@needs_estimation.first, auto_selected: true, easy_mode: true)
        return
      end
    end
  end

  # GET /meal_records/1
  # GET /meal_records/1.json
  def show
  end

  # GET /meal_records/new
  def new
    @meal_record = MealRecord.new
  end

  # GET /meal_records/1/edit
  def edit
    if params[:from_email].present? && params[:easy_mode].present?
      if @meal_record.forced_carbs_estimate_grams.present?
        # Means that somebody has already estimated this meal_record
        redirect_to meal_records_estimate_url(auto_select: true), notice: 'That meal was already estimated.'
      end
    end
  end

  # POST /meal_records
  # POST /meal_records.json
  # POST /users/:user_id/meal_records.json
  def create

    meal_records = MealRecord
    meal_records = @user.meal_records if @user

    @meal_record = meal_records.new(meal_record_params)

    respond_to do |format|
      if @meal_record.save

        Meal.assign_to_last_or_create_by_meal_record(@meal_record)

        # This sends an email to the admin team
        fork do
          Notifier.send_new_meal_record_uploaded_notification(@user, @meal_record).deliver
        end
        format.html { redirect_to @meal_record, notice: 'Meal record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @meal_record }
      else
        format.html { render action: 'new' }
        format.json {
          if @meal_record.errors.messages.any? && @meal_record.errors.messages[:created_at].present?
            if params[:ignore_if_duplicate].present?

              @meal_record = MealRecord.where(created_at: DateTime.parse(meal_record_params[:created_at])).first

              render action: 'show', status: :created, location: @meal_record
              return
            end
          end

          render json: @meal_record.errors, status: :unprocessable_entity

        }
      end
    end
  end

  # PATCH/PUT /meal_records/1
  # PATCH/PUT /meal_records/1.json
  def update

    respond_to do |format|
      mr_params = meal_record_params
      # If you don't send this through the form I will put it to nil
      mr_params[:forced_carbs_estimate_grams] = nil unless mr_params[:forced_carbs_estimate_grams].present?
      if @meal_record.update(mr_params)

        if params[:notify_user].present?
          @meal_record.user.send_push_notification(sample_notification,
            content_available: true,
            custom_data: {
              meal_record_id: @meal_record.id,
              action: 'update_meal_record'
            }
          )
        end


        format.html {
          redirect_to @meal_record, notice: 'Meal record was successfully updated.' unless params[:easy_mode]
          redirect_to meal_records_estimate_url(auto_select: true), notice: 'Meal record was successfully updated.' if params[:easy_mode]
        }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @meal_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meal_records/1
  # DELETE /meal_records/1.json
  def destroy
    @meal_record.destroy
    respond_to do |format|
      format.html { redirect_to meal_records_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meal_record
      @meal_record = MealRecord.find(params[:id])
    end

    def set_user
      @user = User.find_by_device_uuid(params[:user_id]) || User.find_by_id(params[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meal_record_params
      params.require(:meal_record).permit(
        :title,
        :size,
        :serving,
        :created_at,
        :carbs_estimate,
        :forced_carbs_estimate_grams,
        :photo,
        :fat_secret_ingredients => [:food_id, :percentage_in_meal_record],
        :ingredients => []
      )
    end

    def query_params
      params.permit(:page, :per_page)
    end

    private
    def sample_notification
      array = [
        "Hello beauty, we have your carbs!",
        "Carbs are there. Check now!",
        "FYI, carbs are there now!",
        "Enjoying your day? Carbs are there now",
        "You and your carbs are amazing. Have a look",
        "I wish I had that dish too. Check your carbs now"
      ]

      if @meal_record.carbs_estimate
        array.push "#{MealRecord::CARBS_ESTIMATE[@meal_record.carbs_estimate - 1]} in carbs. Make that count!"
        array.push "#{MealRecord::CARBS_ESTIMATE[@meal_record.carbs_estimate - 1]} in carbs. That was soooo good!"

        if @meal_record.carbs_estimate == 1
          array.push "Low in carbs. AMAZING!"
          array.push "Low in carbs. Couldn't do better!"
          array.push "That low in carbs really made my day! Check that out"
          array.push "I am speechless. See how great you did"
        end
      end

      array.sample
    end
end
