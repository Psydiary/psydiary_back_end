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
      expect(json[:errors]).to eq(["Email can't be blank", "Ip address can't be blank"])
    end

    it "can return an error response when the user is not in a legal state" do
      post "/api/v1/users", params: @u4
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(422)
      expect(json[:errors]).to eq(["Must be in a state where psyilocybin use is legal to create an account"])
    end
  end

  describe 'login a user' do
    before :each do
      @p1 = Protocol.create!(name: "Stamets", description: "words", dose_days:"Thursday, Friday, Saturday, Sunday", dosage: 0.1, protocol_duration: 4, break_duration: 4, other_notes: "Take with 500mg of Lion's Mane extract powder and 100mg of Niacin Vit B3")
      @u1 = User.create!(name: "Existing User", email: "existing_user@gmail.com", password: "1234", protocol_id: @p1.id, ip_address: "73.153.161.252")
    end

    it 'POST /login' do
      post "/api/v1/login", params: {"email": @u1.email, "password": @u1.password}
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(json[:data][:attributes].keys).to include(:name ,:email, :protocol_id, :data_sharing)
    end

    it 'will send back an error message if user email doesnt exist' do
      post "/api/v1/login", params: {"email": "b", "password": @u1.password}
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(json[:errors]).to include("Account not found")
    end

    it 'will send back an error message if user password is wrong' do
      post "/api/v1/login", params: {"email": @u1.email, "password": "hello world"}
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(json[:errors]).to include("Incorrect password")
    end
  end
    
  context '#show' do
    before :each do
      @p1 = Protocol.create!(name: "Stamets", description: "words", dose_days:"Thursday, Friday, Saturday, Sunday", dosage: 0.1, protocol_duration: 4, break_duration: 4, other_notes: "Take with 500mg of Lion's Mane extract powder and 100mg of Niacin Vit B3")
      @u1 = User.create!(name: "Existing User", email: "existing_user@gmail.com", password: "1234", protocol_id: @p1.id, ip_address: "2601:282:4300:aef0:3c11:257d:152b:f5ad")
    end

    context "when successful" do
      it "returns a user" do
        get "/api/v1/users/#{@u1.id}"

        expect(response.status).to eq(200)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data].keys).to include(:id, :type, :attributes)
        expect(json[:data][:id]).to eq(@u1.id.to_s)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:attributes].keys).to include(:name, :email, :protocol_id, :data_sharing)
        expect(json[:data][:attributes][:name]).to eq(@u1[:name])
      end
    end

    context "when unsuccessful" do
      it "returns an error message" do
        get "/api/v1/users/98689"

        expect(response.status).to eq(404)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:errors]).to eq("Couldn't find User with 'id'=98689")
      end
    end
  end

  context "#edit" do
    before do
      protocol = create(:protocol)
      @user = create(:user, protocol_id: protocol.id, ip_address: "73.153.161.252")
    end
    
    it 'Happy Path: GET /api/v1/users/:id/settings' do
      get "/api/v1/users/#{@user.id}/settings"

      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      data = json[:data]
      attributes = json[:data][:attributes]

      expect(data.keys).to eq([:id, :type, :attributes]) 
      expect(data[:id]).to be_an String
      expect(data[:type]).to be_a String 
      expect(data[:attributes]).to be_a Hash 
      
      expect(attributes.keys).to eq([:name, :email, :protocol, :data_sharing]) 
      expect(attributes[:name]).to be_a String
      expect(attributes[:email]).to be_a String
      expect(attributes[:data_sharing]).to be_a(TrueClass).or be_a(FalseClass)
      expect(attributes[:protocol]).to be_a Hash
      expect(attributes[:protocol][:id]).to be_a Integer
      expect(attributes[:protocol][:name]).to be_a String
    end

    it 'Sad Path: GET /api/v1/users/:id/settings' do
      get "/api/v1/users/one/settings"

      expect(response.status).to eq(404)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:errors]).to eq("Couldn't find User with 'id'=one")
    end
  end

  context '#update' do
    before :each do
      @p1 = Protocol.create!(name: "Stamets", description: "words", dose_days:"Thursday, Friday, Saturday, Sunday", dosage: 0.1, protocol_duration: 4, break_duration: 4, other_notes: "Take with 500mg of Lion's Mane extract powder and 100mg of Niacin Vit B3")
      @u1 = User.create!(name: "Existing User", email: "existing_user@gmail.com", password: "1234", protocol_id: @p1.id, ip_address: "73.153.161.252")
      @u4 = User.create!(name: "Existing User 2", email: "existing_user_2@gmail.com", password: "1234", protocol_id: @p1.id, ip_address: "73.153.161.252")
      @u2 = attributes_for(:user)
      @u3 = attributes_for(:user, email: "existing_user@gmail.com")
    end

    it "PUT /users/:id" do
      put "/api/v1/users/#{@u1.id}", params: @u2
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(json[:data][:attributes].keys).to include(:name, :email, :protocol_id, :data_sharing)
      expect(json[:data][:attributes][:name]).to include(@u2[:name])
      expect(json[:data][:attributes][:description]).to eq(@u2[:description])
      expect(json[:data][:attributes][:unit_price]).to eq(@u2[:unit_price])
    end

    it "can return an error response when the email was already taken" do
      put "/api/v1/users/#{@u4.id}", params: @u3
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(422)
      expect(json[:errors]).to eq(["Email has already been taken"])
    end
  end
  context '#update_protocol' do
    before :each do
      @p1 = Protocol.create!(name: "Stamets", description: "words", dose_days:"Thursday, Friday, Saturday, Sunday", dosage: 0.1, protocol_duration: 4, break_duration: 4, other_notes: "Take with 500mg of Lion's Mane extract powder and 100mg of Niacin Vit B3")
      @p2 = Protocol.create!(name: "Nightcap", description: "take at night", days_between_dose: 3, dosage: 0.2, protocol_duration: 4, break_duration: 3, other_notes: "Taken in the evening")
      @u1 = User.create!(name: "Existing User", email: "existing_user@gmail.com", password: "1234", protocol_id: @p1.id, ip_address: "73.153.161.252")
      @u4 = User.create!(name: "Existing User 2", email: "existing_user_2@gmail.com", password: "1234", protocol_id: @p1.id, ip_address: "73.153.161.252")
      @u2 = attributes_for(:user)
      @u3 = attributes_for(:user, protocol_id: @p2.id)
    end

    it "PATCH users/:user_id/users" do
      patch "/api/v1/users/#{@u1.id}/update_protocol", params: @u3
      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.status).to eq(200)
      expect(json[:data][:attributes].keys).to include(:name, :email, :protocol_id, :data_sharing)
      expect(json[:data][:attributes][:protocol_id]).to eq(@p2[:protocol_id])
    end
  end
end