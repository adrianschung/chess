class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :set_layout_variables
  
  def after_sign_in_path_for(*)
    games_path
  end

  def set_layout_variables
    if current_player
      @my_games = current_player.game.where(state: [1, 2])
    end
  end
end
