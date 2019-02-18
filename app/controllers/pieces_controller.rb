class PiecesController < ApplicationController
  def update
    # stops opponent from moving current players pieces, keep commented for local testing.
    return redirect_to game_path(game) unless current_player == piece_player
    current_piece.move_to!(new_square_params)
    flash[:notice] = "#{piece_player.playername} is in check" if game.check?(piece_player)
    game.check_endgame(current_piece.player)
    redirect_to game_path(game)
  end

  private

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
