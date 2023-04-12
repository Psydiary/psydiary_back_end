require 'rails_helper'

describe Protocol do
  describe 'relationships' do
    it {should have_many :user}
  end

  describe 'validations' do
    it { should validate_presence_of :dosage }
    it { should validate_presence_of :days_between_dose }
    it { should validate_presence_of :dose_days }
    xit { should validate_presence_of :daysbetween_xor_dosedays }
    it { should validate_presence_of :protocol_duration }
    it { should validate_presence_of :break_duration }
  end
end