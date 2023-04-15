FactoryBot.define do
  factory :daily_log_entry do
    mood { Faker::Emotion.adjective }
    depression_score { Faker::Number.between(from: 1, to: 10) }
    anxiety_score { Faker::Number.between(from: 1, to: 10) }
    sleep_score { Faker::Number.between(from: 1, to: 10) }
    energy_levels { Faker::Number.between(from: 1, to: 10) }
    exercise { Faker::Number.between(from:1, to: 5) }
    meditation { Faker::Number.between(from:1, to: 60) }
    sociability { Faker::Number.between(from:1, to: 3) }
    notes { Faker::Hipster.paragraph }
  end
end