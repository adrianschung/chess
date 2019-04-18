class RoomChannel < ApplicationCable::Channel
  def subscribed
    game = Game.find params[:room]
    stream_for game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def move
  end
end
