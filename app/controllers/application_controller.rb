class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def after_sign_in_path_for(*)
    games_path
  end

  private

  def valid_player
    if current_user != @game.white_player || current_user != @game.black_player
      flash[:error] = 'You are not participating in this game'
      redirect_to games_path
    end
  end
end
