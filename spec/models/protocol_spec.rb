require 'rails_helper'

describe Protocol do
  describe 'relationships' do
    it {should have_many :users}
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :dosage }
    it { should validate_numericality_of :dosage }
    it { should validate_numericality_of :days_between_dose }
    it { should validate_presence_of :protocol_duration }
    it { should validate_presence_of :break_duration }
    it { should validate_presence_of :description }

    context "#daysbetween_xor_dosedays custom validation" do
      let(:protocol) { Protocol.create(name: "Test Protocol", description: "This is a test protocol", dosage: 1.5, days_between_dose: 2, dose_days: "Monday, Wednesday, Friday", protocol_duration: "1 month", break_duration: "1 week") }

      it "returns an error if both days_between_dose and dose_days are present" do
        expect(protocol).to be_invalid
        expect(protocol.errors.full_messages).to eq(["Specify number of days between dose or days of the week you would like to dose, not both"])
      end

      it "returns an error if neither days_between_dose and dose_days are present" do
        protocol.days_between_dose = nil
        protocol.dose_days = nil

        expect(protocol).to be_invalid
        expect(protocol.errors.full_messages).to eq(["Specify number of days between dose or days of the week you would like to dose, not both"])
      end
    end
  end
end