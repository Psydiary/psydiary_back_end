class MicrodoseLogEntry < ApplicationRecord
  belongs_to :user

  validates :dosage, presence: true, numericality: { greater_than: 0 }
  validates_presence_of :mood_before,
                        :mood_after,
                        :environment,
                        :intensity

  enum intensity: %w(low medium high)
  enum sociability: %w(social anxious withdrawn)

  def self.user_entries(user_id)
    where("user_id = #{user_id}")
  end
end