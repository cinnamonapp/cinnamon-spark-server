namespace :meals do
  task :reset => :environment do |t, args|
    puts "Rake => Erasing all Meal"
    # Erase all meals
    Meal.delete_all
    MealRecord.update_all(:meal_id => nil)

    @users = User.all
    puts "Rake => Working on #{@users.count} users"
    @users.each do |user|
      @meal_records = user.meal_records.where(:meal_id => nil)
      @meal_records = @meal_records.order(:created_at => :asc)
      puts "Rake => Working on #{@meal_records.count} meal_records of user with id=#{user.id}"

      last_meal = nil
      @meal_records.each_with_index do |meal_record, index|
        puts "Rake => Working on meal_record with id=#{meal_record.id}"
        should_push_meal_record = false

        if index > 0
          previous_meal_record = @meal_records[index-1]
          if meal_record.created_at - previous_meal_record.created_at < Meal::TIME_SPAN_BETWEEN_MEAL_RECORDS
            should_push_meal_record = true
          end
        end

        if should_push_meal_record
          last_meal.meal_records.push meal_record
        else
          last_meal = Meal.create(
            :meal_records => MealRecord.where(:id => meal_record.id),
            :user => user
          )
        end

        last_meal.created_at = last_meal.meal_records.least_recent.created_at
        last_meal.save

      end
    end

  end
end
