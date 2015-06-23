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

      # Send a push notification to a meal record's owner
      send_push_notification_for_comment(@comment)

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

  def send_push_notification_for_comment(comment=nil)
    if comment.present?
      message             = "Someone left a comment on your dish"
      related_meal_record = comment.meal_record
      sender              = comment.user
      receiver            = related_meal_record.user

      if sender.present? && sender.username.present?
        message = "#{sender.username} left a comment on your dish"
      end

      # Send notification only if sender isn't the receiver
      if sender != receiver
        Rails.logger.info "Sending push notification (new comment) to user (id=#{receiver.id})"
        send_push_notification_to_user(receiver, message,
          content_available: true,
          custom_data: {meal_record_id: related_meal_record.id}
        )

      end
    end
  end
end
