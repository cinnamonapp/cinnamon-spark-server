namespace :notifications do
  task :send_picture_reminder => :environment do |t, args|

    include ActionView::Helpers::DateHelper

    @users = User.all
    puts "Rake => Working on #{@users.count} users"
    @users.each do |user|

      meals_hours = {
        breakfast: 9,
        lunch: 13,
        dinner: 19
      }

      user_time = user.current_time
      user_hour = user_time.hour

      its_time = (user_hour == meals_hours[:breakfast] || user_hour == meals_hours[:lunch] || user_hour == meals_hours[:dinner])
      message = ""

      if user_hour == meals_hours[:breakfast]
        message = "Want me to help you eat well to feel great all day long? Snap a photo!"
      elsif user_hour == meals_hours[:lunch]
        message = "Shouldn't we be having lunch by now? Where's that picture?"
      elsif user_hour == meals_hours[:dinner]
        message = "Healthy eating is like falling in love. You and I are dating. Shall we document?"
      end

      if its_time
        # If the user has not taken any picture
        meal_records_within = user.meal_records.created_within(2.hours)

        unless meal_records_within.any?
          puts "Rake => Send notification to user with id=#{user.id} \n        - user_hour=#{user_hour} - message='#{message}'"
        else
          puts "Rake => User with id=#{user.id} has already uploaded (at least) a picture \n        - last_created='#{time_ago_in_words(meal_records_within.most_recent.created_at)} ago'"
        end
      else
        puts "Rake => It's not the right time for user with id=#{user.id} \n        - user_hour=#{user_hour} - Looking for #{meals_hours}"
      end

    end

  end
end
