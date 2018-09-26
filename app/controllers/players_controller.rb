class PlayersController < ApplicationController
  def show
    @player = Player.find(params[:id])
  end

  def myprofile
    @player = current_player
  end
end
