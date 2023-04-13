require 'rails_helper'

describe 'Users API', type: :request do
  describe 'create a user' do
    before :each do
      @p1 = Protocol.create!(name: "Stamets", description: "words", dose_days:"Thursday, Friday, Saturday, Sunday", dosage: 0.1, protocol_duration: 4, break_duration: 4, other_notes: "Take with 500mg of Lion's Mane extract powder and 100mg of Niacin Vit B3")
      User.create!(name: "Existing User", email: "existing_user@gmail.com", password: "1234", protocol_id: @p1.id)
      @u1 = attributes_for(:user, protocol_id: @p1.id)
      @u2 = attributes_for(:user, email: "existing_user@gmail.com", protocol_id: @p1.id)
      @u3 = attributes_for(:user, email: nil)

    end

    it "POST /items" do
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
      expect(json[:errors]).to eq(["Protocol must exist", "Email can't be blank"])
    end
  end
end