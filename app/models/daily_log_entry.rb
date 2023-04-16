class DailyLogEntry < ApplicationRecord
  belongs_to :user
  
  enum exercise: %w(aerobic strength cardio yoga sport)
  enum sociability: %w(social anxious withdrawn)
end