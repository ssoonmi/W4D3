# == Schema Information
#
# Table name: session_tokens
#
#  id         :bigint(8)        not null, primary key
#  token      :string           not null
#  user_id    :integer          not null
#  device     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SessionToken <ApplicationRecord
  validates :token, presence: true

  after_initialize :ensure_session_token

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

    def self.find_by_credentials(user_name, token)
      # user = User.find_by(user_name: user_name)
      # return user if user && user.is_password?(password)
      # nil
    end

    def self.generate_session_token
      SecureRandom::urlsafe_base64
    end

    def ensure_session_token
      self.token ||= SessionToken.generate_session_token
    end

    def reset_session_token!
      self.update!(token: SessionToken.generate_session_token)
      self.token
    end


end
