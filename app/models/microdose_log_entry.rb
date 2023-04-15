class MicrodoseLogEntry < ApplicationRecord
  belongs_to :user

  enum intensity: %w(low medium high)
  enum sociability: %w(social anxious withdrawn)

  def self.user_entries(user_id)
    where("user_id = #{user_id}")
  end
end