class PlayersController < ApplicationController
  before_action :authenticate_user!, only: [:edit]
  
  def show
  end

  def edit
    current_player.update_attributes(user_params)
  end

  private

  def user_params
    params.permit(:avatar, :country, :birthyear)
  end

  helper_method :current_player
  def current_player
    @current_player ||= Player.find(params[:id])
  end
end
