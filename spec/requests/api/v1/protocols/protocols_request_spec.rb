require 'rails_helper'

RSpec.describe "Protocols API", type: :request do
  context "#show" do
    let(:protocol) { Protocol.create!(name: "Test Protocol", description: "This is a test protocol", dosage: 1.5, dose_days: "Monday, Wednesday, Friday", protocol_duration: 4, break_duration: 1, other_notes: "Taken in the evening") }

    context "when successful" do
      it "returns a protocol" do
        get "/api/v1/protocols/#{protocol.id}"

        expect(response).to be_successful

        protocol_response = JSON.parse(response.body, symbolize_names: true)
        
        expect(protocol_response[:data].keys).to eq([:id, :type, :attributes])
        expect(protocol_response[:data][:id]).to eq(protocol.id.to_s)
        expect(protocol_response[:data][:type]).to eq("protocol")
        expect(protocol_response[:data][:attributes].size).to eq(8)
        expect(protocol_response[:data][:attributes][:name]).to eq(protocol.name)
        expect(protocol_response[:data][:attributes][:description]).to eq(protocol.description)
        expect(protocol_response[:data][:attributes][:dosage]).to eq(protocol.dosage)
        expect(protocol_response[:data][:attributes][:days_between_dose]).to eq(nil)
        expect(protocol_response[:data][:attributes][:dose_days]).to eq(protocol.dose_days)
        expect(protocol_response[:data][:attributes][:protocol_duration]).to eq(protocol.protocol_duration)
        expect(protocol_response[:data][:attributes][:break_duration]).to eq(protocol.break_duration)
        expect(protocol_response[:data][:attributes][:other_notes]).to eq(protocol.other_notes)
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

  context "#index" do
    let!(:protocol) { Protocol.create!(name: "Fadiman", description: "This is a test protocol", days_between_dose: 3, dosage: 0.2, protocol_duration: 4, break_duration: 3, other_notes: "Taken in the morning") }
    let!(:protocol_2) { Protocol.create!(name: "Stamets", description: "This is the other protocol", dose_days:"Thursday, Friday, Saturday, Sunday", dosage: 0.1, protocol_duration: 4, break_duration: 4, other_notes: "Take with 500mg of Lion's Mane extract powder and 100mg of Niacin Vit B3") }
    let!(:protocol_3) { Protocol.create!(name: "Nightcap", description: "Yet another protocol", days_between_dose: 3, dosage: 0.2, protocol_duration: 4, break_duration: 3, other_notes: "Taken in the evening") }

    context "when successful" do
      it "returns a list of all protocols" do
        get "/api/v1/protocols"

        expect(response).to be_successful

        protocol_response = JSON.parse(response.body, symbolize_names: true)

        expect(protocol_response[:data]).to be_an(Array)
        expect(protocol_response[:data].size).to eq(3)
        expect(protocol_response[:data][0].keys).to eq([:id, :type, :attributes])
        expect(protocol_response[:data][0][:attributes].size).to eq(8)
        expect(protocol_response[:data][0][:attributes][:name]).to eq(protocol.name)
        expect(protocol_response[:data][1][:attributes][:name]).to eq(protocol_2.name)
        expect(protocol_response[:data][2][:attributes][:name]).to eq(protocol_3.name)
      end
    end
  end

  describe "#create" do
    context "upon receiving a valid request" do
      before do
        3.times do
          create(:protocol)
        end

        @protocol_params = ({
          id: 60,
          name: "Noe Pagac",
          days_between_dose: 4,
          dose_days: nil,
          dosage: 0.33,
          description: "treats allergy symptoms",
          protocol_duration: 2,
          break_duration: 4,
          other_notes: "Vitae facere voluptatum pariatur quo."
        })
        
        @headers = {"CONTENT_TYPE" => "application/json"}
      end

      it "can successfully creates a new protocol" do
        expect(Protocol.count).to eq(3)

        post "/api/v1/protocols", headers: @headers, params: @protocol_params, as: :json

        expect(response.status).to eq(201)
        expect(Protocol.count).to eq(4)

        parsed = JSON.parse(response.body, symbolize_names: true)

        data = parsed[:data]
        attributes = data[:attributes]

        expect(data.keys).to eq([:id, :type, :attributes])
        expect(attributes.keys).to eq([
          :name, 
          :days_between_dose, 
          :dose_days, 
          :dosage,
          :description,
          :protocol_duration,
          :break_duration,
          :other_notes
        ])

        expect(data[:id]).to be_a String
        expect(data[:type]).to be_a String
        expect(data[:attributes]).to be_a Hash
        expect(attributes[:name]).to be_a String
        expect(attributes[:days_between_dose]).to be_an(Integer).or be_nil
        expect(attributes[:dose_days]).to be_a(String).or be_nil
        expect(attributes[:dosage]).to be_a(Float)
        expect(attributes[:description]).to be_a(String)
        expect(attributes[:protocol_duration]).to be_an(Integer)
        expect(attributes[:break_duration]).to be_an(Integer)
        expect(attributes[:other_notes]).to be_a(String).or be_nil
      end
    end

    context "upon recieving an invalid request" do 
      before do
        @protocol_params = ({
          id: 60,
          name: " ",
          days_between_dose: 4,
          dose_days: nil,
          dosage: "thirty three milligrams",
          description: nil,
          protocol_duration: "two weeks",
          break_duration: 4,
          other_notes: "Vitae facere voluptatum pariatur quo."
        })
        
        @headers = {"CONTENT_TYPE" => "application/json"}
      end

      it "returns an error message for missing attributes and/or invalid data types" do
        post "/api/v1/protocols", headers: @headers, params: @protocol_params, as: :json
        parsed = JSON.parse(response.body, symbolize_names: true)
        
        
        expect(response).to have_http_status(400)
        expect(parsed[:message]).to eq("Protocol was not created. Please enter valid attributes")
        expect(parsed[:errors]).to eq(["Name can't be blank", "Description can't be blank", "Protocol duration is not a number", "Dosage is not a number"])
      end
    end
  end
end