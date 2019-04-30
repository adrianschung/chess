class GamesController < ApplicationController
  before_action :authenticate_player!
  before_action :validate_player!, only: :forfeit
  helper_method :current_game
  helper_method :render_piece

  def index
    @games = Game.where(state: 0).where.not(white_player_id: current_player.id)
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params.merge(white_player: current_player))
    if @game.valid?
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @pieces = current_game.pieces.where(captured: false)
    @chess_board = Games::RenderChessboard.call(@pieces)
  end

  def update
    if current_game.valid? && current_player != current_game.white_player
      current_game.update(black_player: current_player, state: 1)
      PlayerMailer.game_joined(current_game).deliver_later
      current_game.add_pieces_to_board
      ActionCable.server.broadcast("room_#{current_game.id}", view: ApplicationController.render(
                                    partial: 'games/chessboard',
                                    locals: { chess_board: board } )
                            )
      redirect_to game_path(current_game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def forfeit
    if current_player == current_game.white_player
      current_game.update(state: 3)
      redirect_to game_path(current_game)
    elsif current_player == current_game.black_player
      current_game.update(state: 4)
      redirect_to game_path(current_game)
    end
  end

  private

  def validate_player!
    if current_player != current_game.white_player && current_player != current_game.black_player
      flash[:alert] = 'You are not participating in this game'
      redirect_to games_path
    else
      true
    end
  end

  def board
    Games::RenderChessboard.call(current_game.pieces.where(captured: false))
  end

  helper_method :current_game
  def current_game
    @current_game ||= Game.find(params[:id])
  end

  def game_params
    params.permit(:name)
  end
end
