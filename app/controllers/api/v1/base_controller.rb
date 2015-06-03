class Api::V1::BaseController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  protected
  def set_user
    @user = User.find_by_device_uuid(params[:user_id]) || User.find_by_id(params[:user_id])
  end

end
