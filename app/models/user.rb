class User < ApplicationRecord
  has_many :daily_log_entries, dependent: :destroy
  has_many :microdose_log_entries, dependent: :destroy
  belongs_to :protocol

  has_secure_password

  validates_presence_of :name, :email, :password, :ip_address
  validates_uniqueness_of :email

  validate :legal_ip_location
  
  enum role: %w(default manager admin)

  private

  def legal_ip_location
    json = IPGeoLocationService.new.user_state(ip_address)
    legal_states = ["Colorado", "California", "Oregon"]
    return if legal_states.include?(json[:state_prov])

    errors.add(:base, "Must be in a state where psyilocybin use is legal to create an account")
  end
end