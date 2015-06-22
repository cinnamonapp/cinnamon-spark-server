class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :meal_record

  validates :meal_record,  presence: true
  validates :user,         presence: true
end
