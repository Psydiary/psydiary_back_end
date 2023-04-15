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
        expect(attributes[:meditation]).to be_an Integer
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
end
