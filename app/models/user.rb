class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :game_events, dependent: :destroy
  has_many :games, dependent: :destroy
  validates :name,presence: true, length: {maximum: 20}

  def self.create_account_by_google(auth, name)
    user = User.find_by(uid: auth.uid, provider: auth.provider)
    unless user
      user = User.create!(email: User.dummy_email_create(auth.provider, auth.uid),
        name: name,
        provider: auth.provider,
        uid: auth.uid, password: Devise.friendly_token[0, 20],
        meta: auth.to_yaml,token: auth.credentials.token)
    end
    user
  end

  def self.dummy_email_create(provider, uid)
    return "#{provider}-#{uid}@email.com"
  end
end
