class ErrorSerializer
  include JSONAPI::Serializer
  attribute :message do |object|
    if object.class == User
      "User could not be created"
    end
  end
  
  attribute :errors do |object|
    errors = object.errors.map do |error|
      error.full_message
    end
  end
end