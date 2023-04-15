class DailyLogEntry < ApplicationRecord
  belongs_to :user

  enum exercise: %w(aerobic strength cardio yoga sport)
end