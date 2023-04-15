module ErrorSerializerHelper
  def err_message(classname)
    return "User could not be created" if classname == User
    return "Protocol was not created. Please enter valid attributes" if classname == Protocol
    return "Microdose log entry was not created. Please enter valid attributes" if classname == MicrodoseLogEntry
  end
end

class ErrorSerializer
  include JSONAPI::Serializer
  extend ErrorSerializerHelper

  attribute :message do |object|
    err_message(object.class)
  end

  attribute :errors do |object|
    errors = object.errors.map do |error|
      error.full_message
    end
  end

  def self.user_not_found
    {errors: "Account not found"}
  end

  def self.incorrect_password
    {errors: "Incorrect password"}
  end
end