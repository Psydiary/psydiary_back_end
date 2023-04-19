class UserEditSerializer
  include JSONAPI::Serializer
  attributes :name, :email, :data_sharing
  attribute :protocol do |attr|
    require 'pry'; binding.pry
    attr[:protocol_name]
    attr[:protocol_id]
  end
end