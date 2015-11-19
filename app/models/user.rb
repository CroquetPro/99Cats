class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    session_token
  end

  def generate_session_token
    SecureRandom::urlsafe_base64
  end

  def ensure_session_token
    self.session_token ||= generate_session_token
    # session_token = session_token || generate_session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    user if user && user.is_password?(password)
  end
end
