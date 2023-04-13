# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
fadiman_description = "This protocol ensures that a long enough break happens between doses allowing for the contrast between the normal days and microdosing days to become apparent. This is deeply important in terms of understanding the benefits of microdosing in your life. The first day after microdosing is what some call the ‘afterglow’ day. A time when the residue from the previous dosage of psilocybin still lingers. The second day after microdosing is what we call a ‘normal’ day. This is when your system is restored to your unique level of homeostasis."
stamets_description = "The Stamets Protocol is a microdosing protocol developed by mycologist Paul Stamets that involves the combination of psilocybin truffles, a functional mushroom called Lion's Mane, and an essential vitamin called Niacin (vitamin B3). The protocol is designed for medium to advanced microdosers and is not recommended for beginners. The addition of Niacin is intended to increase the absorption of active mushroom compounds throughout the body. The protocol consists of four days on and three days off, with a maximum duration of one month, followed by a two to four-week break. Lion's Mane can also be consumed on the off-days."
nightcap_description = "The Nightcap Protocol involves microdosing psilocybin just before bedtime instead of in the morning, potentially optimizing the theta brainwave state and improving sleep quality. While the benefits are based on anecdotal reports and more research is needed, microdosers have reported feeling refreshed in the morning and avoiding mild nausea associated with morning microdosing."

Protocol.create!(name: "Fadiman", description: fadiman_description, days_between_dose: 3, dosage: 0.2, protocol_duration: 4, break_duration: 3, other_notes: "Taken in the morning")
Protocol.create!(name: "Stamets", description: stamets_description, dose_days:"Thursday, Friday, Saturday, Sunday", dosage: 0.1, protocol_duration: 4, break_duration: 4, other_notes: "Take with 500mg of Lion's Mane extract powder and 100mg of Niacin Vit B3")
Protocol.create!(name: "Nightcap", description: nightcap_description, days_between_dose: 3, dosage: 0.2, protocol_duration: 4, break_duration: 3, other_notes: "Taken in the evening")

User.create!(name: "Tori Enyart", email: "torienyart@gmail.com", password: "1234", protocol_id: 1)
User.create!(name: "Bobby Luly", email: "bobbyluly@gmail.com", password: "5678", protocol_id: 2)

