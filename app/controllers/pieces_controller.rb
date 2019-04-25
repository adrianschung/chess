class PiecesController < ApplicationController

  def update
    return redirect_to game_path(game) if current_player.id != current_piece.player_id
    current_piece.move_to!(new_square_params)
    game.check_endgame(current_piece.player)
    GameChannel.broadcast_to(game, view: ApplicationController.render(
                                    partial: 'games/chessboard',
                                    locals: { chess_board: board } )
                            )
  end

  private

  def board
    Games::RenderChessboard.call(game.pieces.where(captured: false))
  end

  def new_square_params
    @params = params.permit(:row, :column, :id)
    @params.each { |k, v| @params[k] = v.to_i }
  end

  def current_piece
    @current_piece ||= Piece.find(params[:id])
  end

  def game
    @game = current_piece.game
  end

  def piece_player
    @piece_player ||= current_piece.player
  end
end
