class User < ApplicationRecord
  has_many :daily_log_entries, dependent: :destroy
  has_many :microdose_log_entries, dependent: :destroy
  belongs_to :protocol

  has_secure_password

  validates_presence_of :name, :email, :password, :ip_address, :on => :create

  validates_uniqueness_of :email

  validate :legal_ip_location
  
  enum role: %w(default manager admin)


  def user_entries
    # microdose_log_entries.or(daily_log_entries).order(created_at: :asc)
    (microdose_log_entries + daily_log_entries).sort_by { |entry| entry.created_at }.reverse
  end

  def self.from_omniauth(response)
    User.find_or_create_by(uid: response[:uid], provider: response[:provider]) do |u|
      u.email = response[:info][:email]
      u.password = SecureRandom.hex(15)
      u.name = response[:info][:name]
      u.data_sharing = false
      u.ip_address = response[:ip_address]
      u.protocol_id = 1
    end
  end

  private

  def legal_ip_location
    if ip_address.blank?
      return
    else
      json = IPGeoLocationService.new.user_state(ip_address)
      legal_states = ["Colorado", "California", "Oregon"]
      return if legal_states.include?(json[:state_prov])
  
      errors.add(:base, "Must be in a state where psyilocybin use is legal to create an account")
    end
  end
end