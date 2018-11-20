class PlayerMailer < ApplicationMailer
  default from: "do-not-reply@chesssenders.com"

  def game_joined(game)
    @opponent = game.black_player
    @player = game.white_player
    mail(to: @player.email,
      subject: "A player has joined your game")
  end
end
