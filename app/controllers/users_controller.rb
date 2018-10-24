class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit]
  
  def show
  end

  def edit
  end

  private

  def user_params
    params.permit(:avatar)
  end

  helper_method :current_player
  def current_player
    @player ||= Player.find(params[:id])
  end
end
