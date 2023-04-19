class UserEditSerializer
  include JSONAPI::Serializer
  attributes :name, :email
  attribute :protocol do |attr|
    { 
      id: attr.protocol_id, 
      name: attr.protocol_name 
    }
  end
  attribute :data_sharing
end