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

  it "user_entries" do
    @p1 = Protocol.create!(name: "Test Protocol", description: "This is a test protocol", dosage: 1.5, dose_days: "Monday, Wednesday, Friday", protocol_duration: 4, break_duration: 1, other_notes: "Taken in the evening")
    @u1 = User.create!(name: "Tori Enyart", email: "torienyart@gmail.com", password: "1234", protocol_id: @p1.id, ip_address: "73.153.161.252")
    @u2 =User.create!(name: "Bobby Luly", email: "bobbyluly@gmail.com", password: "5678", protocol_id: @p1.id, ip_address: "73.153.161.252")
    @mde1 = create(:microdose_log_entry, user_id: @u1.id)
    @mde2 = create(:microdose_log_entry, user_id: @u1.id)
    @mde3 = create(:microdose_log_entry, user_id: @u1.id)
    @mde4 = create(:microdose_log_entry, user_id: @u1.id)
    @mde5 = create(:microdose_log_entry, user_id: @u1.id)
    @mde6 = create(:microdose_log_entry, user_id: @u2.id)
    @mde7 = create(:microdose_log_entry, user_id: @u2.id)
    @dle1 = create(:daily_log_entry, user_id: @u1.id)
    @dle2 = create(:daily_log_entry, user_id: @u1.id)


    expect(@u1.user_entries).to include(@mde1, @mde2, @mde3, @mde4, @mde5, @dle1, @dle2)
  end
end