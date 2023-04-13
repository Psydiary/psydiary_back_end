require 'rails_helper'

RSpec.describe "Protocols API", type: :request do
  context "#show" do
    let(:protocol) { Protocol.create!(name: "Test Protocol", description: "This is a test protocol", dosage: 1.5, dose_days: "Monday, Wednesday, Friday", protocol_duration: "1 month", break_duration: "1 week") }

    context "when successful" do
      it "returns a protocol" do
        get "/api/v1/protocols/#{protocol.id}"

        expect(response).to be_successful

        protocol_response = JSON.parse(response.body, symbolize_names: true)
        
        expect(protocol_response[:data].keys).to eq([:id, :type, :attributes])
        expect(protocol_response[:data][:id]).to eq(protocol.id.to_s)
        expect(protocol_response[:data][:type]).to eq("protocol")
        expect(protocol_response[:data][:attributes][:name]).to eq(protocol.name)
        expect(protocol_response[:data][:attributes][:description]).to eq(protocol.description)
        expect(protocol_response[:data][:attributes][:dosage]).to eq(protocol.dosage)
        expect(protocol_response[:data][:attributes][:days_between_dose]).to eq(nil)
        expect(protocol_response[:data][:attributes][:dose_days]).to eq(protocol.dose_days)
        expect(protocol_response[:data][:attributes][:protocol_duration]).to eq(protocol.protocol_duration)
        expect(protocol_response[:data][:attributes][:break_duration]).to eq(protocol.break_duration)
      end
    end

    context "when unsuccessful" do
      it "returns an error message for invalid id" do
        get "/api/v1/protocols/986986"

        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(404)
        expect(parsed[:errors]).to eq("Couldn't find Protocol with 'id'=986986")
      end
    end
  end
end