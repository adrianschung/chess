class SpecialMovesController < ApplicationController
  def edit_promotion
    current_game
  end

  def promotion
    pawn.update_attributes(piece_params)
    redirect_to game_path(current_game)
  end

  private

  def piece_params
    params.require(:piece).permit(:type)
  end

  def current_game
    @current_game ||= Game.find(params[:game_id])
  end

  def game_pieces
    current_game.pieces
  end

  def pawn
    game_pieces.where(row: 7).or(game_pieces.where(row: 0).where(type: 'Pawn'))
  end
end
