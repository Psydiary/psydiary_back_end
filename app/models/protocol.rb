class Protocol < ApplicationRecord
  validates_presence_of :name,
                        :dosage,
                        :protocol_duration,
                        :break_duration,
                        :description
  validates_numericality_of :days_between_dose, allow_nil: true
  validates_numericality_of :protocol_duration, :dosage
  validate :daysbetween_xor_dosedays
  
  has_many :users

  enum status: %w(default custom)

  def self.default_protocols
    where(status: 0)
  end

  def self.custom_protocols
    where(status: 1)
  end

  def self.protocols_by_user(user_id)
    where("created_by  = #{user_id}").or(where"created_by  = 0")
  end

  private

  def daysbetween_xor_dosedays
    return if days_between_dose.blank? ^ dose_days.blank?

    errors.add(:base, 'Specify number of days between dose or days of the week you would like to dose, not both')
  end
end