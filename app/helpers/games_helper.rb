module GamesHelper
  def set_class(piece)
    return 'droppable' if piece.nil?
#    return if current_player.id != piece.player_id
    Pieces::Disabled.call(piece) ? 'draggable' : 'droppable'
  end
end
