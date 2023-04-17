require 'rails_helper'

RSpec.describe "Protocols API", type: :request do
  before :each do
    @u1 = create(:user, ip_address: "2601:282:4300:aef0:3c11:257d:152b:f5ad")
    @u2 = create(:user, ip_address: "2601:282:4300:aef0:3c11:257d:152b:f5ad")
    @p4 = create(:protocol, created_by: @u1.id)
    @p5 = create(:protocol, created_by: @u2.id)
  end

  context "#show" do
    let(:p) { Protocol.create!(name: "Test Protocol", description: "This is a test protocol", dosage: 1.5, dose_days: "Monday, Wednesday, Friday", protocol_duration: 4, break_duration: 1, other_notes: "Taken in the evening") }

    context "when successful" do
      it "returns a protocol" do
        get "/api/v1/users/#{@u1.id}/protocols/#{p.id}"

        expect(response).to be_successful

        protocol_response = JSON.parse(response.body, symbolize_names: true)
        
        expect(protocol_response[:data].keys).to eq([:id, :type, :attributes])
        expect(protocol_response[:data][:id]).to eq(p.id.to_s)
        expect(protocol_response[:data][:type]).to eq("protocol")
        expect(protocol_response[:data][:attributes].size).to eq(9)
        expect(protocol_response[:data][:attributes][:name]).to eq(p.name)
        expect(protocol_response[:data][:attributes][:description]).to eq(p.description)
        expect(protocol_response[:data][:attributes][:dosage]).to eq(p.dosage)
        expect(protocol_response[:data][:attributes][:days_between_dose]).to eq(nil)
        expect(protocol_response[:data][:attributes][:dose_days]).to eq(p.dose_days)
        expect(protocol_response[:data][:attributes][:protocol_duration]).to eq(p.protocol_duration)
        expect(protocol_response[:data][:attributes][:break_duration]).to eq(p.break_duration)
        expect(protocol_response[:data][:attributes][:other_notes]).to eq(p.other_notes)
      end
    end

    context "when unsuccessful" do
      it "returns an error message for invalid id" do
        get "/api/v1/users/#{@u1.id}/protocols/986986"

        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(404)
        expect(parsed[:errors]).to eq("Couldn't find Protocol with 'id'=986986")
      end
    end
  end

  context "#index" do
    before :each do
      @u1 = create(:user, ip_address: "2601:282:4300:aef0:3c11:257d:152b:f5ad")
      @u2 = create(:user, ip_address: "2601:282:4300:aef0:3c11:257d:152b:f5ad")
      Protocol.destroy_all
      @p1 = Protocol.create(name: "Fadiman", description: "This is a test protocol", days_between_dose: 3, dosage: 0.2, protocol_duration: 4, break_duration: 3, other_notes: "Taken in the morning")
      @p2 = Protocol.create!(name: "Stamets", description: "This is the other protocol", dose_days:"Thursday, Friday, Saturday, Sunday", dosage: 0.1, protocol_duration: 4, break_duration: 4, other_notes: "Take with 500mg of Lion's Mane extract powder and 100mg of Niacin Vit B3")
      @p3 = Protocol.create!(name: "Nightcap", description: "Yet another protocol", days_between_dose: 3, dosage: 0.2, protocol_duration: 4, break_duration: 3, other_notes: "Taken in the evening")
      @p4 = create(:protocol, created_by: @u1.id)
      @p5 = create(:protocol, created_by: @u2.id)
    end

    context "when successful" do
      it "returns a list of all protocols specific to the user" do
        get "/api/v1/users/#{@u1.id}/protocols"

        expect(response).to be_successful

        protocol_response = JSON.parse(response.body, symbolize_names: true)

        expect(protocol_response[:data]).to be_an(Array)
        expect(protocol_response[:data].size).to eq(4)
        expect(protocol_response[:data][0].keys).to eq([:id, :type, :attributes])
        expect(protocol_response[:data][0][:attributes].size).to eq(9)
        expect(protocol_response[:data][0][:attributes][:name]).to eq(@p1.name)
        expect(protocol_response[:data][1][:attributes][:name]).to eq(@p2.name)
        expect(protocol_response[:data][2][:attributes][:name]).to eq(@p3.name)
        expect(protocol_response[:data][3][:attributes][:created_by]).to eq(@u1.id)
      end
    end
  end

  describe "#create" do
    context "upon receiving a valid request" do
      before do
        Protocol.destroy_all
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

        post "/api/v1/users/#{@u1.id}/protocols", headers: @headers, params: @protocol_params, as: :json

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
          :other_notes,
          :created_by
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
        post "/api/v1/users/#{@u1.id}/protocols", headers: @headers, params: @protocol_params, as: :json
        parsed = JSON.parse(response.body, symbolize_names: true)
        
        
        expect(response).to have_http_status(400)
        expect(parsed[:message]).to eq("Protocol was not created. Please enter valid attributes")
        expect(parsed[:errors]).to eq(["Name can't be blank", "Description can't be blank", "Protocol duration is not a number", "Dosage is not a number"])
      end
    end
  end
end