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

    @meal_records = @meal_records.limit(params[:limit]) if params[:limit]

    @meal_records = @meal_records.order(:created_at => :desc)
  end

  # GET /meal_records/1
  # GET /meal_records/1.json
  def show
  end

  # GET /meal_records/new
  def new
    @meal_record = MealRecord.new
    # Notifier.send_new_meal_record_uploaded_notification(User.first, MealRecord.first).deliver
  end

  # GET /meal_records/1/edit
  def edit
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
        fork do
          Notifier.send_new_meal_record_uploaded_notification(@user, @meal_record).deliver
        end
        format.html { redirect_to @meal_record, notice: 'Meal record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @meal_record }
      else
        format.html { render action: 'new' }
        format.json { render json: @meal_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meal_records/1
  # PATCH/PUT /meal_records/1.json
  def update
    respond_to do |format|
      if @meal_record.update(meal_record_params)
        @meal_record.user.send_push_notification("Carbs are there. Check now")

        format.html { redirect_to @meal_record, notice: 'Meal record was successfully updated.' }
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
      params.require(:meal_record).permit(:title, :size, :carbs_estimate, :photo)
    end
end
