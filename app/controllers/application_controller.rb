class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filted :set_layout_variables
  
  def after_sign_in_path_for(*)
    games_path
  end

  def set_layout_variables
    @my_games = current_player.games.where(state: [1, 2])
  end
end
