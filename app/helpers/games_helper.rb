module GamesHelper
  def set_class(piece)
    return 'droppable' if piece.nil?
    Pieces::Enabled.call(piece) ? 'draggable' : 'droppable'
  end
end
