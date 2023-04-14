require 'rails_helper'

describe 'Users API', type: :request do
  describe 'create a user' do
    before :each do
      @p1 = Protocol.create!(name: "Stamets", description: "words", dose_days:"Thursday, Friday, Saturday, Sunday", dosage: 0.1, protocol_duration: 4, break_duration: 4, other_notes: "Take with 500mg of Lion's Mane extract powder and 100mg of Niacin Vit B3")
      User.create!(name: "Existing User", email: "existing_user@gmail.com", password: "1234", protocol_id: @p1.id, ip_address: "73.153.161.252")
      @u1 = attributes_for(:user, protocol_id: @p1.id, ip_address: "2601:282:4300:aef0:3c11:257d:152b:f5ad")
      @u2 = attributes_for(:user, email: "existing_user@gmail.com", protocol_id: @p1.id, ip_address: "2601:282:4300:aef0:3c11:257d:152b:f5ad")
      @u3 = attributes_for(:user, email: nil)
      @u4 = attributes_for(:user, protocol_id: @p1.id, ip_address: "69.146.140.81")
    end

    it "POST /users" do
      post "/api/v1/users", params: @u1
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(201)
      expect(json[:data][:attributes].keys).to include(:name, :email, :protocol_id, :data_sharing)
      expect(json[:data][:attributes][:name]).to include(@u1[:name])
    end

    it "can return an error response when the email was already taken" do
      post "/api/v1/users", params: @u2
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(422)
      expect(json[:errors]).to eq(["Email has already been taken"])
    end

    it "can return an error response when the user wasn't created" do
      post "/api/v1/users", params: @u3
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(422)
      expect(json[:errors]).to eq(["Protocol must exist", "Email can't be blank", "Ip address can't be blank"])
    end

    it "can return an error response when the user is not in a legal state" do
      post "/api/v1/users", params: @u4
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(422)
      expect(json[:errors]).to eq(["Must be in a state where psyilocybin use is legal to create an account"])
    end
  end
end