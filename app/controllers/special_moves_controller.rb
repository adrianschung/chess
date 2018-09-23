class SpecialMovesController < ApplicationController
  def castle
    params = castle_params
    @game = Game.find(params[:game_id])
    player = get_player(@game)
    king = @game.pieces.where(type: 'King').find_by(player: player)
    Pieces::King::Castle.call(king, params[:direction])
    redirect_to game_path(@game)
  end

  private

  def castle_params
    params.permit(:direction, :game_id)
  end

  def get_player(game)
    return game.white_player if game.state == "White's Turn"
    return game.black_player if game.state == "Black's Turn"
  end
end
