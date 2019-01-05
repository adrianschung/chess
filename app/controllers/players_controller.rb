class PlayersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  
  def show
  end

  def edit
  end

  def update
    current_player.update_attributes(player_params)
  end

  private

  def player_params
    params.permit(:avatar, :country, :birthyear)
  end

  helper_method :player_profile
  def player_profile
    @player_profile ||= Player.find(params[:id])
  end
end
