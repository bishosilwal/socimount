class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[facebook twitter instagram]

  def self.from_omniauth(auth)
    if(auth.class == Hash)
      where(email: auth['info']['email']).first_or_create do |user|
        user.email = auth['info']['email']
        user.password = Devise.friendly_token[0, 20]
        user.token = auth['credentials']['token']
      end
    else
      where(email: auth.info.email).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.token = auth.credentials.token
      end
    end
  end
end
