require 'rails_helper'

describe MicrodoseLogEntry, type: :model do
  describe "relationships" do
    it {should belong_to :user}
  end

  describe "validations" do
    it { should validate_presence_of :dosage }
    it { should validate_numericality_of(:dosage).is_greater_than(0) }
    it { should validate_presence_of :mood_before }
    it { should validate_presence_of :mood_after }
    it { should validate_presence_of :environment }
    it { should validate_presence_of :intensity }
  end
end