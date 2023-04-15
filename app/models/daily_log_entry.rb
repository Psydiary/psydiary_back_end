class DailyLogEntry < ApplicationRecord
  belongs_to :user

  enum exercise: %w(cardio yoga weights cycling climbing running)
  enum sociability: %w(social anxious withdrawn)
end