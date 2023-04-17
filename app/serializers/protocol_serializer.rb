class ProtocolSerializer
  include JSONAPI::Serializer
  attributes :name, :days_between_dose, :dose_days, :dosage, :description, :protocol_duration, :break_duration, :other_notes, :created_by
end
