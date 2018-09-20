module Pieces
  class CheckObstruction < ApplicationService
    def initialize(piece, new_square)
      @piece = piece
      @game = piece.game
      @new_square = new_square
    end

    def call
      return check_horizontal_squares if piece.row == opponent_king.row
      return check_vertical_squares if piece.column == opponent_king.column
      return check_diagonal_squares if (piece.row - opponent_king.row).abs ==
                                       (piece.column - opponent_king.column).abs
    end

    private

    def check_horizontal_squares
      obstructable_squares = []
      if moving_left?
        for x in (opponent_king.column + 1)...piece.column
          obstructable_squares.push([piece.row, x])
        end
      else
        for x in (piece.column + 1)...opponent_piece.column
          obstructable_squares.push([piece.row, x])
        end
      end
      obstructable_squares.each do |square|
        new_square = { row: square[0], column: square[1] }
        opponent_pieces.each do |piece|
          return true if piece.valid_move?(new_square)
        end
      end
    end

    def check_vertical_squares
      obstructable_squares = []
      if moving_up?
        for x in (opponent_king.row + 1)...piece.row
          obstructable_squares.push([x, piece.column])
        end
      else
        for x in (piece.row + 1)...opponent_piece.row
          obstructable_squares.push([x, piece.column])
        end
      end
      obstructable_squares.each do |square|
        new_square = { row: square[0], column: square[1] }
        opponent_pieces.each do |piece|
          return true if piece.valid_move?(new_square)
        end
      end
    end

    def moving_up?
      piece.row > opponent_king.row ? true : false
    end

    def moving_left?
      piece.column > opponent_king.column ? true : false
    end

    def opponent_king
      opponent_king = piece.opponent_king
    end

    def opponent_pieces
      opponent_pieces = piece.opponent_pieces
    end

    attr_accessor :game, :piece, :new_square
  end
end
