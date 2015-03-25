require 'test_helper'

class MealRecordsControllerTest < ActionController::TestCase
  setup do
    @meal_record = meal_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:meal_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create meal_record" do
    assert_difference('MealRecord.count') do
      post :create, meal_record: { carbs_estimate: @meal_record.carbs_estimate, photo: @meal_record.photo, size: @meal_record.size }
    end

    assert_redirected_to meal_record_path(assigns(:meal_record))
  end

  test "should show meal_record" do
    get :show, id: @meal_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @meal_record
    assert_response :success
  end

  test "should update meal_record" do
    patch :update, id: @meal_record, meal_record: { carbs_estimate: @meal_record.carbs_estimate, photo: @meal_record.photo, size: @meal_record.size }
    assert_redirected_to meal_record_path(assigns(:meal_record))
  end

  test "should destroy meal_record" do
    assert_difference('MealRecord.count', -1) do
      delete :destroy, id: @meal_record
    end

    assert_redirected_to meal_records_path
  end
end
