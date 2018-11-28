class PlayerMailer < ApplicationMailer
  default from: "do-not-reply@chesssenders.com"

  def game_joined(game)
    @game = game
    @opponent = game.black_player
    @player = game.white_player
    mail(to: @player.email,
      subject: "A player has joined your game")
  end

  def message_sent(message)
    @conversation = message.conversation
    if message.player == @conversation.sender
      @player = @conversation.recipient
    else
      @player = @conversation.sender
    end
    @sender = message.player
    mail(to: @player.email,
      subject: "A player has sent you an message")
  end
end
