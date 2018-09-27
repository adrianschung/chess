class Bishop < Piece
  before_save :default_pic

  def default_pic
    self.picture = 'whitebishop.png' if color == 'White'
    self.picture = 'blackbishop.png' if color == 'Black'
  end

  def valid_move?(new_square)
    return false unless (new_square[:row] - row).abs == (new_square[:column] - column).abs
    super &&
      valid_movement?(7, -7, new_square[:row] - row) &&
      valid_movement?(7, -7, new_square[:column] - column)
  end
end
