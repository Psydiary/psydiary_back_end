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
    it { should validate_numericality_of :protocol_duration }
    it { should validate_presence_of :break_duration }
    it { should validate_presence_of :description }

    context "#daysbetween_xor_dosedays custom validation" do
      let(:protocol) { Protocol.create(name: "Test Protocol", description: "This is a test protocol", dosage: 1.5, days_between_dose: 2, dose_days: "Monday, Wednesday, Friday", protocol_duration: "1 month", break_duration: "1 week") }

      it "returns an error if both days_between_dose and dose_days are present" do
        expect(protocol).to be_invalid
        expect(protocol.errors.full_messages).to eq(["Protocol duration is not a number", "Specify number of days between dose or days of the week you would like to dose, not both"])
      end

      it "returns an error if neither days_between_dose and dose_days are present" do
        protocol.days_between_dose = nil
        protocol.dose_days = nil

        expect(protocol).to be_invalid
        expect(protocol.errors.full_messages).to eq(["Protocol duration is not a number", "Specify number of days between dose or days of the week you would like to dose, not both"])
      end
    end
  end

  describe 'class methods' do
    describe '.default_protocols' do
      it 'returns the default protocol' do
        default_1 = Protocol.create(name: "Default Protocol 1", description: "This is the default protocol", dosage: 1.5, days_between_dose: 2, protocol_duration: 4, break_duration: 1, other_notes: "Optional extra notes", created_by: 0)
        default_2 = Protocol.create(name: "Default Protocol 2", description: "This is another default protocol", dosage: 1.75, days_between_dose: 3, protocol_duration: 6, break_duration: 2, other_notes: "Optional extra notes", created_by: 0)
        custom_1 = Protocol.create(name: "Custom Protocol ", description: "This is a custom protocol", dosage: 1.25, days_between_dose: 2, protocol_duration: 8, break_duration: 2, other_notes: "Optional extra notes", created_by: 1)

        expect(Protocol.default_protocols).to eq([default_1, default_2])
        expect(Protocol.default_protocols).to_not include(custom_1)

        default_3 = Protocol.create(name: "Default Protocol 3", description: "This is a third default protocol", dosage: 2.25, days_between_dose: 2, protocol_duration: 5, break_duration: 1, other_notes: "Optional extra notes", status: 0)

        expect(Protocol.default_protocols).to eq([default_1, default_2, default_3])
      end
    end

    describe '.custom_protocols' do
      it 'returns the custom protocols' do
        default_1 = Protocol.create(name: "Default Protocol 1", description: "This is the default protocol", dosage: 1.5, days_between_dose: 2, protocol_duration: 4, break_duration: 1, other_notes: "Optional extra notes", status: 0)
        custom_1 = Protocol.create(name: "Custom Protocol ", description: "This is a custom protocol", dosage: 1.25, days_between_dose: 2, protocol_duration: 8, break_duration: 2, other_notes: "Optional extra notes", status: 1)

        expect(Protocol.custom_protocols).to eq([custom_1])
        expect(Protocol.custom_protocols).to_not include(default_1)

        custom_2 = Protocol.create(name: "Custom Protocol 2", description: "This is another custom protocol", dosage: 1.25, days_between_dose: 2, protocol_duration: 8, break_duration: 2, other_notes: "Optional extra notes", status: 1)

        expect(Protocol.custom_protocols).to eq([custom_1, custom_2])
      end
    end

    describe '.protocols_by_user' do
      before :each do
        @u1 = create(:user, ip_address: "2601:282:4300:aef0:3c11:257d:152b:f5ad")
        @u2 = create(:user, ip_address: "2601:282:4300:aef0:3c11:257d:152b:f5ad")
        Protocol.destroy_all
        @p1 = Protocol.create(name: "Fadiman", description: "This is a test protocol", days_between_dose: 3, dosage: 0.2, protocol_duration: 4, break_duration: 3, other_notes: "Taken in the morning")
        @p2 = Protocol.create!(name: "Stamets", description: "This is the other protocol", dose_days:"Thursday, Friday, Saturday, Sunday", dosage: 0.1, protocol_duration: 4, break_duration: 4, other_notes: "Take with 500mg of Lion's Mane extract powder and 100mg of Niacin Vit B3")
        @p3 = Protocol.create!(name: "Nightcap", description: "Yet another protocol", days_between_dose: 3, dosage: 0.2, protocol_duration: 4, break_duration: 3, other_notes: "Taken in the evening")
        @p4 = create(:protocol, created_by: @u1.id)
        @p5 = create(:protocol, created_by: @u2.id)
      end

      it 'returns protocols a user created and the defaults' do
        expect(Protocol.protocols_by_user(@u1.id)).to include(@p1, @p2, @p3, @p4)
        expect(Protocol.protocols_by_user(@u1.id)).to_not include(@p5)
      end
    end

    describe '.protocols_by_user' do
      before :each do
        @u1 = create(:user, ip_address: "2601:282:4300:aef0:3c11:257d:152b:f5ad")
        @u2 = create(:user, ip_address: "2601:282:4300:aef0:3c11:257d:152b:f5ad")
        Protocol.destroy_all
        @p1 = Protocol.create(name: "Fadiman", description: "This is a test protocol", days_between_dose: 3, dosage: 0.2, protocol_duration: 4, break_duration: 3, other_notes: "Taken in the morning")
        @p2 = Protocol.create!(name: "Stamets", description: "This is the other protocol", dose_days:"Thursday, Friday, Saturday, Sunday", dosage: 0.1, protocol_duration: 4, break_duration: 4, other_notes: "Take with 500mg of Lion's Mane extract powder and 100mg of Niacin Vit B3")
        @p3 = Protocol.create!(name: "Nightcap", description: "Yet another protocol", days_between_dose: 3, dosage: 0.2, protocol_duration: 4, break_duration: 3, other_notes: "Taken in the evening")
        @p4 = create(:protocol, created_by: @u1.id)
        @p5 = create(:protocol, created_by: @u2.id)
      end

      it 'returns protocols a user created and the defaults' do
        expect(Protocol.protocols_by_user(@u1.id)).to include(@p1, @p2, @p3, @p4)
        expect(Protocol.protocols_by_user(@u1.id)).to_not include(@p5)
      end

      it 'returns defaults if the userid is nil' do
        expect(Protocol.protocols_by_user(nil)).to include(@p1, @p2, @p3)
      end
    end
  end
end