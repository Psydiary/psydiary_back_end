class Protocol < ApplicationRecord
  validates_presence_of :name,
                        :dosage,
                        :protocol_duration,
                        :break_duration,
                        :description
  validates_numericality_of :days_between_dose, allow_nil: true
  validates_numericality_of :dosage
  validate :daysbetween_xor_dosedays
  
  has_many :users

  private

  def daysbetween_xor_dosedays
    return if days_between_dose.blank? ^ dose_days.blank?

    errors.add(:base, 'Specify number of days between dose or days of the week you would like to dose, not both')
  end
end