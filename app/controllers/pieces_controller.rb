class PiecesController < ApplicationController
  def update
    # stops opponent from moving current players pieces, keep commented for local testing.
    return redirect_to game_path(game) unless current_player == current_piece.player
    current_piece.move_to!(new_square_params)
    flash[:notice] = "#{current_piece.player.playername} is in check" if game.check?(current_piece.player)
    game.check_endgame(current_piece.player)
    redirect_to game_path(game)
  end

  private

  def new_square_params
    @params = params.permit(:row, :column, :id)
    @params.each { |k, v| @params[k] = v.to_i }
  end

  def game
    @game = current_piece.game
  end

  def current_piece
    @piece || Piece.find(params[:id])
  end
end
