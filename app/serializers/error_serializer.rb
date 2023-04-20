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

  def self.invalid_combo
    {errors: "Passwords must match"}
  end

  def self.blank_email
    {errors: "Email cant be blank"}
  end
  
  def self.invalid_password
    {errors: "Current Password is invalid"}
  end

  def self.wrong_login_type
    {errors: "It seems like you don't usually use a social account.... try again another way"}
  end
end