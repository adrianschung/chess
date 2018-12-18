class King < Piece
  before_save :default_pic

  def default_pic
    self.picture = 'whiteking.png' if color == 'White'
    self.picture = 'blackking.png' if color == 'Black'
  end

  def valid_move?(new_square)
    super &&
      valid_movement?(1, -1, new_square[:row] - row) &&
      valid_movement?(1, -1, new_square[:column] - column) &&
      valid_space?(new_square) || castle(new_square)
  end

  def castle!(direction)
    Pieces::King::Castle.call(self, direction)
  end

  def can_move?
    king_moves = {}
    ((self.row - 1)..(self.row + 1)).each do |x|
      ((self.column - 1)..(self.column + 1)).each do |y|
        king_moves[:row] = x
        king_moves[:column] = y
        return true if self.valid_move?(king_moves)
      end
    end
    false
  end

  def valid_space?(new_space)
    opponent_pieces.each do |piece|
      return false if piece.valid_move?(new_space)
    end
  end

  def castle(new_space)
    return false if !rook || self.moves != 0 || Pieces::Obstruction.call(self, rook)
    if new_space[:column] == 2
      rook = game.pieces.where(row: new_space[:row], column: 0, type: 'Rook', captured: false).first
    elsif new_space[:column] == 6
      rook = game.pieces.where(row: new_space[:row], column: 7, type: 'Rook', captured: false).first
    end
  end
end
