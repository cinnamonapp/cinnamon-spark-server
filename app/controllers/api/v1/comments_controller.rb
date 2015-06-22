class Api::V1::CommentsController < Api::V1::BaseController

  before_filter :set_meal_record, only: :index
  before_filter :set_comment, only: [:show]

  def index
    @comments = Comment.all
    @comments = @user.comments if @user.present?
    @comments = @meal_record.comments if @meal_record.present?
    @comments = @comments.order(created_at: :desc)
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render action: :show, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end


  private
  def comment_params
    params.require(:comment).permit(:meal_record_id, :user_id, :message)
  end

  def set_comment
    @comment = Comment.find_by_id(params[:id])
  end

  def set_meal_record
    @meal_record = MealRecord.find_by_id(params[:meal_record_id])
  end
end
