class DailyLogEntry < ApplicationRecord
  belongs_to :user

  enum exercise: %w(arobic, strength, cardio, yoga, sport)

end