require 'openssl'

class User < ApplicationRecord
  validates :email, :username, presence: true, uniqueness: true
  has_many :questions
  
  attr_accessor :password
  
  validates_presence_of :password, on: :create
  validates_confirmation_of :password
  
  before_save :encrypt_password
  
  def encrypt_password
    if password_present?
      password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))
      password_hash = User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST))
    end
  end
  
  def hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end
  
  def authenticate(email, password)
    user = find_by(email: email)
    if user.present? && user.password_hash = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST)
    )
      user
    else
      nil
    end
  end
end
