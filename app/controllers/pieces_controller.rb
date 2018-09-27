class PiecesController < ApplicationController
  def update
    # stops opponent from moving current players pieces, keep commented for local testing.
      # unless current_player == @piece.player
      #   return redirect_to game_path(game)
      # end
    current_piece.move_to!(new_square_params)
    flash[:notice] = "#{game.white_player.playername} is in check" if game.check?(game.white_player)
    flash[:notice] = "#{game.black_player.playername} is in check" if game.check?(game.black_player)
    game.update(state: 3) if game.check? && game.checkmate?(white_player)
    game.update(state: 4) if game.check? && game.checkmate?(black_player)

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
