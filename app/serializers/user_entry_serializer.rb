class UserEntrySerializer
  include JSONAPI::Serializer

  attributes :id, :user_id, :created_at, :updated_at

  attribute :type do |object|
    object.class.name
  end

  attribute :mood_before, if: Proc.new { |record| 
    record[:mood_before] }

  attribute :mood_after, if: Proc.new { |record| 
    record[:mood_after] }

  attribute :dosage, if: Proc.new { |record| 
    record[:dosage] }

  attribute :intensity, if: Proc.new { |record| 
    record[:intensity] }

  attribute :sociability, if: Proc.new { |record| 
    record[:sociability] }
  
  attribute :journal_prompt, if: Proc.new { |record| 
    record[:journal_prompt] }
    
  attribute :journal_entry, if: Proc.new { |record| 
  record[:journal_entry] }

  attribute :environment, if: Proc.new { |record| 
    record[:environment] }
    
  attribute :other_notes, if: Proc.new { |record| 
    record[:other_notes]}
  
  attribute :mood, if: Proc.new { |record| 
    record[:mood] }
   
  attribute :depression_score, if: Proc.new { |record| 
    record[:depression_score] }
    
  attribute :anxiety_score, if: Proc.new { |record| 
    record[:anxiety_score] }
    
  attribute :sleep_score, if: Proc.new { |record| 
    record[:sleep_score] }
  
  attribute :exercise, if: Proc.new { |record| 
    record[:exercise] }

  attribute :meditation, if: Proc.new { |record| 
    record[:meditation] }

  attribute :notes, if: Proc.new { |record| 
    record[:notes] }
end