module KingMove
  def king_can_move?(king)
    king_moves = {}
    ((king.row - 1)..(king.row +1)).each do |x|
      ((king.column - 1)..(king.column + 1).each do |y|
        king_moves[:row] = x
        king_moves[:column] = y
        return true if king.valid_move?(king_moves)
      end
    end
    false
  end
end
