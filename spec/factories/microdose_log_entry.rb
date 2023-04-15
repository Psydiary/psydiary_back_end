FactoryBot.define do
  factory :microdose_log_entry do
    mood_before { Faker::Emotion.adjective }
    mood_after { Faker::Emotion.adjective }
    environment { Faker::House.room }
    dosage { Faker::Number.decimal(r_digits:2) }
    intensity { ['low', 'medium', 'high'].sample }
    sociability { ['social', 'anxious', 'withdrawn'].sample }
    journal_prompt { Faker::Hipster.sentence }
    journal_entry { Faker::Hipster.paragraph }
  end
end