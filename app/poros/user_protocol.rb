class UserProtocol
  attr_reader :id, 
              :name, 
              :email, 
              :data_sharing, 
              :protocol_id,
              :protocol_name

  def initialize(user, protocol) 
    @id = user.id
    @name = user.name
    @email = user.email
    @data_sharing = user.data_sharing
    @protocol_name = protocol.name
    @protocol_id = protocol.id
  end
end