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
      end
      if castle?(new_square)
        if new_square[:column] == 2
          @rook.update_attributes(column: 3)
          self.update_attributes(column: 2)
        elsif new_square[:column] == 6
          @rook.update_attributes(column: 5)
          self.update_attributes(column: 6)
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

  def castle?(new_space)
    @rook = nil
    return false unless new_space[:column] == 2 || new_space[:column] == 7 || self.moves == 0
    if new_space[:column] == 2
      @rook = game.pieces.where(row: new_space[:row], column: 0, type: 'Rook', captured: false).first
    elsif new_space[:column] == 6
      @rook = game.pieces.where(row: new_space[:row], column: 7, type: 'Rook', captured: false).first
    end
    return false if !@rook || Pieces::Obstruction.call(self, @rook)
  end
end
