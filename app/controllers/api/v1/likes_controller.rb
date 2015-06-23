class Api::V1::LikesController < Api::V1::BaseController

  before_filter :set_like, only: [:show]

  def show
  end

  def create
    @like = Like.new(like_params)

    if @like.save
      send_push_notification_for_like(@like)

      render action: :show, status: :created, location: @like
    else
      if params[:delete_if_duplicate].present?
        puts @like.errors.inspect
        if @like = Like.find_by_meal_record_id_and_user_id(like_params[:meal_record_id], like_params[:user_id])
          @like.delete
        end
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


  def send_push_notification_for_like(like=nil)
    if like.present?
      message             = "Someone liked your dish"
      related_meal_record = like.meal_record
      sender              = like.user
      receiver            = related_meal_record.user

      if sender.present? && sender.username.present?
        message = "#{sender.username} liked your dish"
      end

      # Send notification only if sender isn't the receiver
      if sender != receiver
        Rails.logger.info "Sending push notification (new like) to user (id=#{receiver.id})"
        send_push_notification_to_user(receiver, message,
          content_available: true,
          custom_data: {meal_record_id: related_meal_record.id}
        )

      end
    end
  end
end
