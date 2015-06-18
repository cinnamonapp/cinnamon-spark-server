module MealRecordsHelper
  def number_of_likes(meal_record)
    meal_record.likes.count
  end

  def has_been_liked(meal_record, user)
    if user.present? and user.likes.where(:meal_record_id => meal_record.id).any?
      return true
    end

    return false
  end
end
