class Piece < ApplicationRecord
  belongs_to :game
  belongs_to :player

  def move_to!(new_square)
    transaction do
      if valid_move?(new_square)
        Pieces::MoveTo.call(self, new_square)
      end
      raise ActiveRecord::Rollback if game.check?(player)
    end
  end

  def color
    Pieces::Color.call(self)
  end

  def can_capture?
    capture_square = { row: row, column: column }
    opponent_pieces.each do |piece|
      return true if piece.valid_move?(capture_square)
    end
    false
  end

  def can_obstruct?
    Pieces::CheckObstruction.call(self, row: opponent_king.row, column: opponent_king.column)
  end

  def opponent_pieces
    @opponent_pieces = game.pieces.where.not(player: player, captured: true)
  end

  def opponent_king
    @opponent_king = game.pieces.where(type: 'King').where.not(player: player).first
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
