class Player < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |player|
      player.email = auth.info.email
      player.password = Devise.friendly_token[0,20]
      player.playername = auth.info.name   # assuming the player model has a name
      # player.image = auth.info.image # assuming the player model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # player.skip_confirmation!
      end
  end

  def self.new_with_session(params, session)
    super.tap do |player|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        player.email = data["email"] if player.email.blank?
      end
    end
  end
end
