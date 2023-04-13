require 'rails_helper'

RSpec.describe "Journal Prompts API" do
  describe "GET /api/v1/journal_prompts" do

    it "returns a journal prompt" do
      @protocol = Protocol.create!(name: "Test", dosage: 0.5, description: "Test", protocol_duration: "1 week", break_duration: "1 week", days_between_dose: 1)
      @user1 = User.create!(name: "Test", email: "test@test.com", address: "123 Test St", password: "test", protocol_id: @protocol.id)
      MicrodoseLogEntry.create!(mood_before: "Happy", mood_after: "Happy", environment: "Home", dosage: 0.5, intensity: 3, sociability: 3, journal_prompt: "", journal_entry: "I went to the park", other_notes: "I felt great", user_id: @user1.id)
      get '/api/v1/journal_prompts/find?=today'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      journal_prompt = JSON.parse(response.body, symbolize_names: true)

      expect(journal_prompt).to be_a(Hash)
      expect(journal_prompt).to have_key(:data)
      expect(journal_prompt[:data]).to be_a(Hash)
      expect(journal_prompt[:data]).to have_key(:id)
      expect(journal_prompt[:data][:id]).to be_a(String)
      expect(journal_prompt[:data]).to have_key(:type)
      expect(journal_prompt[:data][:type]).to be_a(String)
      expect(journal_prompt[:data]).to have_key(:attributes)
      expect(journal_prompt[:data][:attributes]).to be_a(Hash)
      expect(journal_prompt[:data][:attributes]).to have_key(:journal_prompt)
      expect(journal_prompt[:data][:attributes][:journal_prompt]).to be_a(String)
    end
  end
end