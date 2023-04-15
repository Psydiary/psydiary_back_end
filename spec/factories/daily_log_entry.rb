FactoryBot.define do
  factory :daily_log_entry do
    mood { Faker::Emotion.adjective }
    depression_score { Faker::Number.between(from: 1, to: 10) }
    anxiety_score { Faker::Number.between(from: 1, to: 10) }
    sleep_score { Faker::Number.between(from: 1, to: 10) }
    energy_levels { Faker::Number.between(from: 1, to: 10) }
    exercise { ['aerobic', 'strength', 'cardio', 'yoga', 'sport'].sample }
    meditation { Faker::Number.between(from:1, to: 60) }
    sociability { ['social', 'anxious', 'withdrawn'].sample }
    notes { Faker::Hipster.paragraph }
  end
end