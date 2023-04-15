require 'rails_helper'

RSpec.describe "Microdose Log API", type: :request do
  describe "#show" do
    let(:protocol_1) { Protocol.create!(name: "Test Protocol", description: "This is a test protocol", dosage: 1.5, dose_days: "Monday, Wednesday, Friday", protocol_duration: 4, break_duration: 1, other_notes: "Taken in the evening") }
    let(:user_1) { create(:user, protocol_id: protocol_1.id, ip_address: "73.153.161.252") }
    let(:microdose_log_1) { MicrodoseLogEntry.create!(user_id: user_1.id, mood_before: "Down", mood_after: "Happy", environment: "The Park", dosage: 1.5, intensity: 0, sociability: 1, journal_prompt: "How was your day?", journal_entry: "Today was a nice day", other_notes: "I felt great today!") }

    context "when successful" do
      it "returns a user's microdose log entry" do
        get "/api/v1/users/#{user_1.id}/microdose_log_entrys/#{microdose_log_1.id}"

        expect(response).to be_successful

        microdose_json = JSON.parse(response.body, symbolize_names: true)

        expect(microdose_json[:data].keys).to eq([:id, :type, :attributes])
        expect(microdose_json[:data][:id]).to eq(microdose_log_1.id.to_s)
        expect(microdose_json[:data][:type]).to eq("microdose_log_entry")
        expect(microdose_json[:data][:attributes].size).to eq(11)
        expect(microdose_json[:data][:attributes][:user_id]).to eq(microdose_log_1.user_id)
        expect(microdose_json[:data][:attributes][:mood_before]).to eq(microdose_log_1.mood_before)
        expect(microdose_json[:data][:attributes][:mood_after]).to eq(microdose_log_1.mood_after)
        expect(microdose_json[:data][:attributes][:environment]).to eq(microdose_log_1.environment)
        expect(microdose_json[:data][:attributes][:dosage]).to eq(microdose_log_1.dosage)
        expect(microdose_json[:data][:attributes][:intensity]).to eq(microdose_log_1.intensity)
        expect(microdose_json[:data][:attributes][:sociability]).to eq(microdose_log_1.sociability)
        expect(microdose_json[:data][:attributes][:journal_prompt]).to eq(microdose_log_1.journal_prompt)
        expect(microdose_json[:data][:attributes][:journal_entry]).to eq(microdose_log_1.journal_entry)
        expect(microdose_json[:data][:attributes][:other_notes]).to eq(microdose_log_1.other_notes)
        expect(microdose_json[:data][:attributes][:created_at]).to eq(microdose_log_1.created_at.strftime("%B %d, %Y"))
      end
    end

    context "when unsuccessful" do
      it "returns a 404 error if the microdose log entry does not exist" do
        get "/api/v1/users/#{user_1.id}/microdose_log_entrys/9999999999"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        microdose_json = JSON.parse(response.body, symbolize_names: true)

        expect(microdose_json[:errors]).to eq("Couldn't find MicrodoseLogEntry with 'id'=9999999999")
      end
    end
  end

  describe "#create" do
    let!(:protocol_1) { Protocol.create!(name: "Test Protocol", description: "This is a test protocol", dosage: 1.5, dose_days: "Monday, Wednesday, Friday", protocol_duration: 4, break_duration: 1, other_notes: "Taken in the evening") }
    let!(:user_1) { create(:user, protocol_id: protocol_1.id, ip_address: "73.153.161.252") }
    let!(:microdose_log_1) { MicrodoseLogEntry.create!(user_id: user_1.id, mood_before: "Down", mood_after: "Happy", environment: "The Park", dosage: 1.5, intensity: 0, sociability: 1, journal_prompt: "How was your day?", journal_entry: "Today was a nice day", other_notes: "I felt great today!") }
    let!(:microdose_log_2) { MicrodoseLogEntry.create!(user_id: user_1.id, mood_before: "Happy", mood_after: "Ecstatic", environment: "Camping", dosage: 2.0, intensity: 1, sociability: 0, journal_prompt: "What did you learn about yourself?", journal_entry: "I've realized some things I'd like to change in my life.", other_notes: "I've still got some processing to do") }

    context "when successful" do
      it "creates a new microdose log entry" do
        microdose_log_params = ({
                                  user_id: user_1.id,
                                  mood_before: "Melancholy",
                                  mood_after: "Apotheosis",
                                  environment: "Camping",
                                  dosage: 2.0,
                                  intensity: 1,
                                  sociability: 0,
                                  journal_prompt: "What are you grateful for?",
                                  journal_entry: "I'm grateful for my support network.",
                                  other_notes: "Feeling loved"
                                })
        headers = {"CONTENT_TYPE" => "application/json"}

        expect(MicrodoseLogEntry.count).to eq(2)
        
        post "/api/v1/users/#{user_1.id}/microdose_log_entrys", headers: headers, params: microdose_log_params, as: :json
        new_microdose_log = MicrodoseLogEntry.last

        expect(response).to be_successful
        expect(response.status).to eq(201)
        expect(MicrodoseLogEntry.count).to eq(3)

        microdose_json = JSON.parse(response.body, symbolize_names: true)

        expect(microdose_json[:data].keys).to eq([:id, :type, :attributes])
        expect(microdose_json[:data][:id]).to eq(MicrodoseLogEntry.last.id.to_s)
        expect(microdose_json[:data][:type]).to eq("microdose_log_entry")
        expect(microdose_json[:data][:attributes].size).to eq(11)
        expect(microdose_json[:data][:attributes][:user_id]).to eq(new_microdose_log.user_id)
        expect(microdose_json[:data][:attributes][:journal_entry]).to eq(new_microdose_log.journal_entry)
      end
    end

    context "when unsuccessful" do
      it "returns a 422 error if the request is missing a required field or invalid" do
        microdose_log_params = ({
                                  user_id: user_1.id,
                                  mood_before: " ",
                                  mood_after: " ",
                                  environment: " ",
                                  dosage: "two",
                                  intensity: " ",
                                  sociability: 0,
                                  journal_prompt: "What are you grateful for?",
                                  journal_entry: "I'm grateful for my support network.",
                                  other_notes: "Feeling loved"
                                })
        headers = {"CONTENT_TYPE" => "application/json"}

        expect(MicrodoseLogEntry.count).to eq(2)
        
        post "/api/v1/users/#{user_1.id}/microdose_log_entrys", headers: headers, params: microdose_log_params, as: :json
        
        expect(MicrodoseLogEntry.count).to eq(2)
        expect(response).to_not be_successful
        expect(response.status).to eq(422)

        microdose_json = JSON.parse(response.body, symbolize_names: true)

        expect(microdose_json[:errors]).to eq(["Dosage is not a number", "Mood before can't be blank", 
                "Mood after can't be blank", "Environment can't be blank", "Intensity can't be blank"])
        expect(microdose_json[:message]).to eq("Microdose log entry was not created. Please enter valid attributes")
      end
    end
  end
end