class SpecialMovesController < ApplicationController
  def castle
    king = current_game.pieces.where(type: 'King').find_by(player: get_player(current_game))
    Pieces::King::Castle.call(king, castle_params[:direction])
    redirect_to game_path(current_game)
  end

  def edit_promotion
    current_game
  end

  def promotion
    pawn.update_attributes(piece_params)
    redirect_to game_path(current_game)
  end

  private

  def castle_params
    params.permit(:direction, :game_id)
  end

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

  def get_player(game)
    return game.white_player if game.state == "White's Turn"
    return game.black_player if game.state == "Black's Turn"
  end
end
