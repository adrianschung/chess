class PlayersController < ApplicationController
  before_action :authenticate_player!, only: [:edit, :update]

  def show
  end

  def edit
    @player = current_player
  end

  def update
    current_player.update_attributes(player_params)
    redirect_to edit_player_path(current_player)
  end

  private

  def player_params
    params.require(:player).permit(:avatar)
  end

  helper_method :player_profile
  def player_profile
    @player_profile ||= Player.find(params[:id])
  end
end
