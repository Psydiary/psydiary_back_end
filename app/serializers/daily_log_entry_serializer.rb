class DailyLogEntrySerializer
  include JSONAPI::Serializer
  attributes  :user_id,
              :mood,
              :depression_score,
              :anxiety_score,
              :sleep_score,
              :energy_levels,
              :notes,
              :meditation,
              :sociability,
              :exercise

  attribute :created_at do |object|
    object.created_at.strftime("%B %d, %Y")
  end
end