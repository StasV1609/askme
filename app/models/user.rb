require 'openssl'

class User < ApplicationRecord
  # Constants
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new
  
  # Associations
  has_many :questions, dependent: :destroy
  
  # Callbacks
  before_save :encrypt_password
  
  # Validations
  validates :username, presence: true, length: { maximum: 40 },
                    format: { with: /\A[a-zA-Z0-9](\w|\.)*[a-zA-Z0-9]+\z/ }
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A[^@\s]+@([^@.\s]+\.)*[^@.\s]+\z/ }
  validates_presence_of :password, on: :create
  validates_confirmation_of :password
  
  attr_accessor :password
  
  def encrypt_password
    if self.password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))
      self.password_hash = User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(
        self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end
  
  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end
  
  def self.authenticate(email, password)
    user = find_by(email: email)
    return nil unless user.present?
    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )
    return user if user.password_hash == hashed_password
    nil
  end
end
