class MicrodoseLogEntry < ApplicationRecord
  belongs_to :user

  enum intensity: %w(low medium high)
  enum sociability: %w(social anxious withdrawn)
end