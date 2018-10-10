class PlayersController < ApplicationController
  def show
    @player = Player.find(params[:id])
  end

  def myprofile
    @player = current_player
  end

  private

  def user_params
    params.permit(:avatar)
  end
end
