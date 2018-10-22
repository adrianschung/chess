class GamesController < ApplicationController
  before_action :authenticate_player!
  before_action :valid_player, only: [:show, :update]
  helper_method :current_game
  helper_method :render_piece

  def index
    @games = Game.where('white_player_id != ?', current_player.id)
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
    @game = current_game
    @pieces = @game.pieces.where(captured: false)
    @chess_board = Games::RenderChessboard.call(@pieces)
  end

  def update
    @game = Game.find(params[:id])
    if @game.valid? && current_player != @game.white_player
      @game.update(black_player: current_player, state: 1)
      @game.add_pieces_to_board
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def multidimensional_grid(pieces)
    grid = []
    (0..7).each do |row|
      grid_row = []
      (0..7).each do |col|
        space = pieces.select { |piece| piece.row == row && piece.column == col }
        grid_row << space.first
      end
      grid << grid_row
    end
    grid
  end

  def current_game
    @current_game ||= Game.find(params[:id])
  end

  def game_params
    params.permit(:name)
  end
end
