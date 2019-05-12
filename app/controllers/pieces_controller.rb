class PiecesController < ApplicationController

  def update
    return redirect_to game_path(game) if current_player.id != current_piece.player_id
    current_piece.move_to!(new_square_params)
    game.check_endgame(current_piece.player)
    ActionCable.server.broadcast("room_#{game.id}",
                                 view: ApplicationController.render(
                                    partial: 'games/chessboard',
                                    locals: { chess_board: board } ),
                                 state: game.state,
                                 x: current_piece.column,
                                 y: current_piece.row
                                )
    head :no_content
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
