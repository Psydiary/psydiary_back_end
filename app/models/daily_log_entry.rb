class DailyLogEntry < ApplicationRecord
  belongs_to :user

  validates_presence_of :user_id
  enum exercise: %w(aerobic strength cardio yoga sport)
  enum sociability: %w(social anxious withdrawn)
end