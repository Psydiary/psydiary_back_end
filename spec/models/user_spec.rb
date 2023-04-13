require 'rails_helper'

describe User, type: :model do
  describe "relationships" do
    it {should have_many :daily_log_entries}
    it {should have_many :microdose_log_entries}
    it {should belong_to :protocol}

  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_uniqueness_of :email }
    it { should have_secure_password}
  end
end