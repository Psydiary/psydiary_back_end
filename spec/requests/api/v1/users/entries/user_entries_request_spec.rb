require 'rails_helper'

describe "user entries" do
  describe "#index" do #NOTE THAT THIS IS A COMBINED INDEX W/ DAILY LOG ENTRIES AS WELL
    before :each do
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
    end
    
    it "can respond w/ all the microdose log entries from a single user" do
      get "/api/v1/users/#{@u1.id}/log_entries"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json[:data].count).to eq(7)


      expect(json[:data].first[:attributes].keys).to include(:id, :mood, :depression_score, :anxiety_score, :sleep_score, :exercise, :meditation, :notes, :user_id)
      expect(json[:data].last[:attributes].keys).to include(:user_id, :mood_before, :mood_after, :environment, :dosage, :intensity, :sociability, :journal_prompt, :journal_entry, :created_at)
    end
  end
end