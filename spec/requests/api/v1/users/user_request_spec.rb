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

  describe '#update' do
    context "Happy Path: PATCH api/v1/users/:id/settings" do
      before do
        @current_password = "password123"
        @user = create(:user, protocol_id: create(:protocol).id, ip_address: "73.153.161.252", password: @current_password, data_sharing: false)
      end

      let(:expected_request_body) do
        {
          data: {
            id: @user.id,
            type: 'user_update',
            attributes: {
              email: @user.email,
              current_password: @current_password,
              new_password: 'password321',
              password_conf: 'password321',
              data_sharing: 'true'
            }
          }
        }
      end

      it "it can receive valid update json and redirect with success message" do
        patch "/api/v1/users/#{@user.id}/settings", params: expected_request_body 

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(api_v1_user_settings_path(@user.id))
      end
    end

    context "Sad Path: PATCH api/v1/users/:id/settings" do
      before do
        @current_password = "password123"
        @user1 = create(:user, protocol_id: create(:protocol).id, ip_address: "73.153.161.252", password: @current_password, data_sharing: false)
        @user2 = create(:user, protocol_id: create(:protocol).id, ip_address: "73.153.161.252", password: @current_password, data_sharing: false)
      end

      let(:duplicate_email_request) do
        {
          data: {
            id: @user2.id,
            type: 'user_update',
            attributes: {
              email: @user1.email,
              current_password: nil,
              new_password: nil,
              password_conf: nil,
              data_sharing: 'true'
            }
          }
        }
      end

      let(:invalid_current_password) do
        {
          data: {
            id: @user2.id,
            type: 'user_update',
            attributes: {
              email: @user2.email,
              current_password: "passworddrowssap",
              new_password: "password321",
              password_conf: "password321",
              data_sharing: 'true'
            }
          }
        }
      end

      let(:invalid_combo) do
        {
          data: {
            id: @user2.id,
            type: 'user_update',
            attributes: {
              email: @user2.email,
              current_password: @current_password,
              new_password: "password321",
              password_conf: "password322",
              data_sharing: 'true'
            }
          }
        }
      end

      let(:blank_email) do
        {
          data: {
            id: @user2.id,
            type: 'user_update',
            attributes: {
              email: nil,
              current_password: @current_password,
              new_password: "password321",
              password_conf: "password321",
              data_sharing: 'true'
            }
          }
        }
      end
    
      it "can return an error response when the email was already taken" do
        patch "/api/v1/users/#{@user2.id}/settings", params: duplicate_email_request
        
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(422)
        expect(json[:errors]).to eq("Validation failed: Email has already been taken")
      end

      # it "can return an error if email is blank" do
      #   patch "/api/v1/users/#{@user2.id}/settings", params: blank_email
      #   require 'pry'; binding.pry
      #   json = JSON.parse(response.body, symbolize_names: true)
      #   expect(response.status).to eq(422)
      #   expect(json[:errors]).to eq("Email cant be blank")
      # end

      it "can return an error if the new password combo doesnt match" do
        patch "/api/v1/users/#{@user2.id}/settings", params: invalid_combo

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(422)
        expect(json[:errors]).to eq("Passwords must match")
      end

      it "can return an error response when the current password given doesnt match or is missing" do
        patch "/api/v1/users/#{@user2.id}/settings", params: invalid_current_password

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(422)
        expect(json[:errors]).to eq("Current Password is invalid")
      end
    end
  end
end