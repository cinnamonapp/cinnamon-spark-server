module Api::V1::DashboardHelper
  def total_hours
    return 24
  end

  def starting_at_hour
    return 0
  end

  def carbs_need_per_hour(daily_carbs_need, total_hours)
    return daily_carbs_need / total_hours
  end

  def carbs_need_for_hour(hour, carbs_need_per_hour, starting_at_hour=0)

    actualHours = hour - starting_at_hour

    return actualHours * carbs_need_per_hour
  end

  def carbs_compare(hour, carbs_value, daily_carbs_need)

    carbs_need_now = carbs_need_for_hour(
      hour,
      carbs_need_per_hour(daily_carbs_need, total_hours),
      starting_at_hour
    )

    carbs_range_now = carbs_need_for_hour(
      hour,
      carbs_need_per_hour(50, total_hours),
      starting_at_hour
    )


    bottom_range = carbs_need_now - carbs_range_now
    top_range = carbs_need_now

    if carbs_value < bottom_range
      return -1
    elsif carbs_value >= bottom_range && carbs_value < top_range
      return 0
    else
      return 1
    end

    return true
  end
end
