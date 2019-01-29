class King < Piece
  before_save :default_pic

  def default_pic
    self.picture = 'whiteking.png' if color == 'White'
    self.picture = 'blackking.png' if color == 'Black'
  end

  def move_to!(new_square)
    transaction do
      if valid_move?(new_square)
        Pieces::MoveTo.call(self, new_square)
        Games::UpdateState.call(game)
      elsif castle?(new_square)
        castle_move(new_square)
        Games::UpdateState.call(game)
      end
      raise ActiveRecord::Rollback if game.check?(player)
    end
  end

  def valid_move?(new_square)
    super &&
      valid_movement?(1, -1, new_square[:row] - row) &&
      valid_movement?(1, -1, new_square[:column] - column) &&
      valid_space?(new_square)
  end

  # determines if king can move out of check
  def can_move?
    king_moves = {}
    ((row - 1)..(row + 1)).each do |x|
      ((column - 1)..(column + 1)).each do |y|
        king_moves[:row] = x
        king_moves[:column] = y
        return true if valid_move?(king_moves)
      end
    end
    false
  end

  private
  
  # prevents king from moving into check
  def valid_space?(new_space)
    opponent_pieces.each do |piece|
      return false if piece.valid_move?(new_space)
    end
  end

  def castle?(new_space)
    return false unless new_space[:column] == (2 || 6) || moves.zero?
    rook = find_rook(new_space)
    return false if rook.nil?
    return false unless valid_rook?(rook)
    true
  end

  def castle_move(new_space)
    if new_space[:column] == 2
      rook = game.pieces.where(row: new_space[:row], column: 0, type: 'Rook', captured: false).first
      update_attributes(column: 2, moves: 1)
      rook.castle(new_space)
    elsif new_space[:column] == 6
      rook = game.pieces.where(row: new_space[:row], column: 7, captured: false).first
      update_attributes(column: 6, moves: 1)
      rook.castle(new_space)
    end
  end

  # finds the correct rook that is castling with king
  def find_rook(king_space)
    if king_space[:column] == 2
      game.pieces.where(row: row, column: 0,
                        type: 'Rook', captured: false).first
    elsif king_space[:column] == 6
      game.pieces.where(row: row, column: 7,
                        type: 'Rook', captured: false).first
    end
  end

  def valid_rook?(rook)
    return false unless rook || !Pieces::Obstruction.call(self, rook) || rook.moves.zero?
    true
  end
end
