require 'rails_helper'

RSpec.describe UserProtocol do
  describe ".class_methods" do
    context "#initialize" do
      before do
        @protocol = create(:protocol)
        @user = create(:user, protocol_id: @protocol.id, ip_address: "73.153.161.252")
      end

      it 'exists' do
        expect(UserProtocol.new(@user, @protocol)).to be_a(UserProtocol)
      end

      it 'has attributes, readable' do
        user_protocol = UserProtocol.new(@user, @protocol)

        expect(user_protocol.id).to eq(@user.id)
        expect(user_protocol.name).to eq(@user.name)
        expect(user_protocol.email).to eq(@user.email)
        expect(user_protocol.data_sharing).to eq(@user.data_sharing)
        expect(user_protocol.protocol_id).to eq(@protocol.id)
        expect(user_protocol.protocol_name).to eq(@protocol.name)
      end
    end
  end
end