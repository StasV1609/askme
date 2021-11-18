require 'openssl'

class User < ApplicationRecord
  # Constants
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new
  VALID_USERNAME_REGEX = /\A[a-zA-Z0–9_]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Associations
  has_many :questions, dependent: :destroy
  
  # Callbacks
  before_save :encrypt_password
  before_save :generate_lowercase_username
  
  # Validations
  validates :username, presence: true, length: { maximum: 40 }, format: { with: VALID_USERNAME_REGEX }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password,  presence: true, on: :create, confirmation: { case_sensitive: true }
  
  # Getters and Setters
  attr_accessor :password

  def self.authenticate(email, password)
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
        password_hash = User.hash_to_string(
          OpenSSL::PKCS5.pbkdf2_hmac(
            password, password_salt, ITERATIONS, DIGEST.length, DIGEST
          )
        )
      end
    end

    def self.hash_to_string(password_hash)
      password_hash.unpack('H*')[0]
    end
      
    def generate_lowercase_username
      self.username.downcase!
    end
end
