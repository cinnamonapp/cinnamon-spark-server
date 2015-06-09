module ApplicationHelper
  def gmt_date_to_user_date(date, user)
    date + user.time_zone.to_i.days
  end
end
