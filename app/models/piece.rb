class Piece < ApplicationRecord
  belongs_to :game
  belongs_to :player

  def move_to!(new_square)
    self.transaction do
      Pieces::MoveTo.call(self, new_square) if valid_move?(new_square)
      fail ActiveRecord::Rollback self.game.check?(self.player)
    end
  end

  def color
    Pieces::Color.call(self)
  end

  protected

  def valid_move?(new_square)
    in_bounds?(new_square[:row], new_square[:column]) &&
      !Pieces::Obstruction.call(self, new_square)
  end

  def in_bounds?(new_row, new_col)
    valid_movement?(7, 0, new_row) && valid_movement?(7, 0, new_col)
  end

  def valid_movement?(max, min, new_pos)
    (new_pos <= max) && (new_pos >= min)
  end
end
