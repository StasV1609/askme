require 'openssl'

class User < ApplicationRecord
  # Constants
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new
  REGEX_USERNAME = /\A[a-zA-Z0–9 _]+\z/
  REGEX_EMAIL = /\A[^@\s]+@([^@.\s]+\.)*[^@.\s]+\z/
  
  # Associations
  has_many :questions, dependent: :destroy
  
  # Callbacks
  before_save :encrypt_password
  
  # Validations
  validates :username, presence: true, length: { maximum: 40 }, format: { with: REGEX_USERNAME }
  validates :email, presence: true, uniqueness: true, format: { with: REGEX_EMAIL }
  validates :password, presence: true, on: :create, confirmation: { case_sensitive: true }
  
  # Setter
  attr_accessor :password
    
  def hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end
  
  def authenticate(email, password)
    user = find_by(email: email)
    return unless user.present?
    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )
    return user if user.password_hash == hashed_password
  end
  
  private
  
    def encrypt_password
      if password.present?
        password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))
        password_hash = User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(
          password, password_salt, ITERATIONS, DIGEST.length, DIGEST)
        )
      end
    end
end
