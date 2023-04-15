FactoryBot.define do
  factory :daily_log_entry do
    mood { Faker::Emotion.noun }
    depression_score { Faker::Number.between(from: 1, to: 10) }
    anxiety_score { Faker::Number.between(from: 1, to: 10) }
    sleep_score { Faker::Number.between(from: 1, to: 10) }
    energy_levels { Faker::Lorem.word }
    notes { Faker::Hipster.paragraph }
    meditation { Faker::Number.between(from: 0, to: 60) }
    sociability { ['social', 'anxious', 'withdrawn'].sample }
    exercise { ['aerobic', 'strength', 'cardio', 'yoga', 'sport'].sample }
  end
end