class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session


  def send_push_notification_to_user(user, message="", options={})
    user.send_push_notification(message, options)
  end
end
