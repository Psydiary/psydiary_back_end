class UserEntrySerializer < ActiveModel::Serializer
  include JSONAPI::Serializer
  # attributes :user_id,
  #            :mood_before,
  #            :mood_after,
  #            :environment,
  #            :dosage,
  #            :intensity,
  #            :sociability,
  #            :journal_prompt,
  #            :journal_entry,
  #            :other_notes,
  #            :mood,
  #            :depression_score,
  #            :anxiety_score,
  #            :sleep_score,
  #            :energy_levels,
  #            :exercise,
  #            :meditation,
  #            :notes

  attributes :id, :user_id, :created_at, :updated_at

  attribute :mood_before, if: :dose_log?

  def dose_log
    require 'pry'; binding.pry
    # object.is_a?(MicrodoseLogEntry)
  end

  attribute :created_at do |object|
    object.created_at.strftime("%B %d, %Y")
  end
end