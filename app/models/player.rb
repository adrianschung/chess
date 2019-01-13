class Player < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  mount_uploader :avatar, AvatarUploader
  attribute :country, :string, default: 'N/A'

  def games
    Game.where(white_player_id: self).or(Game.where(black_player_id: self))
  end

  def games_in_progress
    games.where(state: [0, 1, 2]).count
  end

  def games_won
    games.where(white_player_id: self, state: 4)
         .or(games.where(black_player_id: self, state: 3)).count
  end

  def games_lost
    games.where(white_player_id: self, state: 3)
         .or(games.where(black_player_id: self, state: 4)).count
  end

  def games_drawn
    games.where(state: 5).count
  end

  def total_games
    games_won + games_lost + games_in_progress + games_drawn
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |player|
      player.email = auth.info.email
      player.password = Devise.friendly_token[0, 20]
      player.playername = auth.info.name
    end
  end

  has_many :games
  has_many :pieces
end
