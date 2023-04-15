class MicrodoseLogEntrySerializer
  include JSONAPI::Serializer
  attributes :user_id,
             :mood_before,
             :mood_after,
             :environment,
             :dosage,
             :intensity,
             :sociability,
             :journal_prompt,
             :journal_entry,
             :other_notes

  attribute :created_at do |object|
    object.created_at.strftime("%B %d, %Y")
  end
end
