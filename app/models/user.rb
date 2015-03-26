class User < ActiveRecord::Base
  has_many :meal_records
end
