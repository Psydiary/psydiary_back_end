class Protocol < ApplicationRecord
  validates_presence_of :dosage,
                        :days_between_dose,
                        :dose_days,
                        :protocol_duration,
                        :break_duration
  validates_numericality_of :days_between_dose, allow_nil: true
  validates_numericality_of :dose_days, allow_nil: true
  validate :daysbetween_xor_dosedays
  
  has_many :user

  private

    def daysbetween_xor_dosedays
      return if days_between_dose.blank? ^ dose_days.blank?

      errors.add(:base, 'Specify number of days between dose or days of the week you would like to dose, not both')
    end
end