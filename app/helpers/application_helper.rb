module ApplicationHelper
  def gmt_date_to_user_date(date, user)
    newdate = date
    newdate += user.time_zone.to_i.hours if user.present? && user.time_zone.present?

    newdate
  end
end
