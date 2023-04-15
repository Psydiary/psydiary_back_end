FactoryBot.define do
  factory :protocol do
    name { Faker::Name.name }
    days_between_dose { Faker::Number.between(from: 1, to: 4) }
    dosage { Faker::Number.decimal(l_digits: 0, r_digits: 2) }
    description { Faker::Cannabis.health_benefit }
    protocol_duration { Faker::Number.between(from: 2, to: 4) }
    break_duration { Faker::Number.between(from: 2, to: 4) }
    other_notes { Faker::Lorem.sentence(word_count: 5) }
  end
end