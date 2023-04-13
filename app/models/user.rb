class User < ApplicationRecord
  has_many :daily_log_entries, dependent: :destroy
  has_many :microdose_log_entries, dependent: :destroy
  belongs_to :protocol

  has_secure_password

  validates_presence_of :name, :email, :password
  validates_uniqueness_of :email
  
  enum role: %w(default manager admin)
end