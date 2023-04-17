require 'rails_helper'

RSpec.describe "DailyLogEntry API", type: :request do

  context "#show" do
    before do
      @user = create(:user, ip_address: "76.131.159.186")

      create(:daily_log_entry, user_id: @user.id)

      @entry = DailyLogEntry.last

      get "/api/v1/users/:id/daily_log_entries/#{@entry.id}"
    end

    context "when successful" do
      it "returns an entry" do
        expect(response).to be_successful

        parsed = JSON.parse(response.body, symbolize_names: true)
        
        data = parsed[:data]
        attributes = parsed[:data][:attributes]

        expect(data.keys).to eq([:id, :type, :attributes])
        expect(attributes.keys).to eq([
          :user_id,
          :mood,
          :depression_score,
          :anxiety_score,
          :sleep_score,
          :energy_levels,
          :notes,
          :meditation,
          :sociability,
          :exercise
        ])
        
        expect(attributes[:user_id]).to be_an Integer
        expect(attributes[:mood]).to be_a String
        expect(attributes[:depression_score]).to be_an Integer
        expect(attributes[:anxiety_score]).to be_an Integer
        expect(attributes[:sleep_score]).to be_an Integer
        expect(attributes[:energy_levels]).to be_an Integer
        expect(attributes[:notes]).to be_a String
        expect(attributes[:meditation]).to be_a String
        expect(attributes[:sociability]).to be_a String
      end

      context "when unsuccessful" do
        it "returns an error message for invalid id" do
          get "/api/v1/users/:id/daily_log_entries/525600"
  
          expect(response).to have_http_status(404)

          parsed = JSON.parse(response.body, symbolize_names: true)

          expect(parsed[:errors]).to eq("Couldn't find DailyLogEntry with 'id'=525600")
        end
  
        it "returns an error message for string instead of integer" do
          get "/api/v1/users/:id/daily_log_entries/five_hundred_twenty_five_thousand_six_hundred_minutes"
  
          expect(response).to have_http_status(404)
          
          parsed = JSON.parse(response.body, symbolize_names: true)
          
          expect(parsed[:errors]).to eq("Couldn't find DailyLogEntry with 'id'=five_hundred_twenty_five_thousand_six_hundred_minutes")
        end
      end
    end
  end

  describe "#create" do
    before :each do
      @p1 = create(:protocol)
      @u1 = create(:user, protocol_id: @p1.id, ip_address: "73.153.161.252")
      @u2 = create(:user, protocol_id: @p1.id, ip_address: "73.153.161.252")
      @dle1 = create(:daily_log_entry, user_id: @u1.id)
      @dle2 = create(:daily_log_entry, user_id: @u1.id)
      @dle3 = attributes_for(:daily_log_entry, user_id: @u1.id)
      @dle4 = attributes_for(:daily_log_entry)
    end

    context "when successful" do
      it "creates a new microdose log entry" do
        post "/api/v1/users/#{@u1.id}/daily_log_entries", params: @dle3
        json = JSON.parse(response.body, symbolize_names: true)

        expect(DailyLogEntry.count).to eq(3)
        expect(response).to be_successful
        expect(response.status).to eq(201)


        expect(json[:data][:type]).to eq("daily_log_entry")
        expect(json[:data][:attributes].keys).to eq([:user_id, :mood, :depression_score, :anxiety_score, :sleep_score, :energy_levels, :notes, :meditation, :sociability, :exercise])
        expect(json[:data][:attributes][:user_id]).to eq(@u1.id)
        expect(json[:data][:attributes][:journal_entry]).to eq(@dle3[:journal_entry])
      end
    end
  end
end
