class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :email, :protocol_id, :data_sharing
end