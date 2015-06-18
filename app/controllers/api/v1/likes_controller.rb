class Api::V1::LikesController < Api::V1::BaseController

  before_filter :set_like, only: [:show]

  def show
  end

  def create
    @like = Like.new(like_params)

    if @like.save
      render action: :show, status: :created, location: @like
    else
      if params[:delete_if_duplicate].present?
        @like = Like.find_by_meal_record_id_and_user_id(like_params[:meal_record_id], like_params[:user_id])
        @like.delete
        render action: :show, status: :created, location: @like
      else
        render json: @like.errors, status: :unprocessable_entity
      end
    end
  end

  private
  def set_like
    @like = Like.find_by_id(params[:id])
  end

  def like_params
    params.require(:like).permit(:meal_record_id, :user_id)
  end

end
