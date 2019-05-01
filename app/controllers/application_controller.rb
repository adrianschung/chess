class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_layout_variables
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(*)
    games_path
  end

  def set_layout_variables
    @my_games = current_player.games.where(state: [0, 1, 2]) if current_player
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:playername, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
