# Highly experimental code ==========

    # WeekDays and TimeFrames for meal_records visualizations

    class WeekDay
      attr_accessor :date,
                    :time_frames # [ MealRecordsTimeFrame ]

      def initialize(params={})

        self.time_frames = []

        self.date = params[:date] if params[:date]
        self.time_frames = params[:time_frames] if params[:time_frames]
      end

      def self.today
        return WeekDay.new(date: Date.today)
      end

      def self.generate_week_days
        # Generate an array of WeekDays
        # Return 2 Weeks of WeekDays from now
        # [Yesterday, TheDayBefore, ...]

        today   = Date.today
        daysago = today - 3.weeks + 1.day
        range   = daysago..today

        return range.to_a.map{|date| WeekDay.new(date: date)}.reverse

      end

    end

    class MealRecordsTimeFrame < Range
      attr_accessor :meal_records # [ MealRecord ]

      def initialize(a, b, c=nil)
        super(a, b, c)

        self.meal_records = []
      end

      # This method generates the following defaults
      # | 08.00 - 10.30 |
      # | 10.30 - 12.00 |
      # | 12.00 - 14.30 |
      # | 14.30 - 17.00 |
      # | 17.00 - 24.00 |

      def self.generate_default_time_frames
        defaults = [
          "08:00".tf_to("10:30"),
          "10:30".tf_to("12:00"),
          "12:00".tf_to("14:30"),
          "14:30".tf_to("17:00"),
          "17:00".tf_to("24:00")
        ]

        return defaults
      end

      # Don't do this at home
      def self.generate_default_time_frames_without_time_zone
        defaults = [
          "06:00".tf_to("08:30"),
          "08:30".tf_to("10:00"),
          "10:00".tf_to("12:30"),
          "12:30".tf_to("15:00"),
          "15:00".tf_to("22:00")
        ]

        return defaults
      end

      def to_time_frame_with_date(date)
        first = DateTime.parse("#{date.to_s} #{self.first}")
        last = DateTime.parse("#{date.to_s} #{self.last}")

        return first..last
      end
    end

# ================
