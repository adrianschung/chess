class UsersController < ApplicationController
  def show
    @player = Player.find(params[:id])
  end

  private

  def user_params
    params.permit(:avatar)
  end
end
