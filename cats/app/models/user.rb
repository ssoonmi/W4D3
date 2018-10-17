# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_name       :string           not null
#

class User < ApplicationRecord
  validates :user_name, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true

  after_initialize :ensure_session_token

  has_many :cats,
    class_name: :Cat,
    foreign_key: :user_id

  has_many :requests,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :CatRentalRequest


  has_many :session_tokens,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :SessionToken

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return user if user && user.is_password?(password)
    nil
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def reset_session_token!
    self.update!(session_token: User.generate_session_token)
    self.session_token
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    bcrypt_pw = BCrypt::Password.new(self.password_digest)
    bcrypt_pw.is_password?(pw)
  end


end
