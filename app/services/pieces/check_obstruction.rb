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
        for x in (piece.column + 1)...opponent_king.column
          obstructable_squares.push([piece.row, x])
        end
      end
      return true if valid_obstruction?(obstructable_squares)
      false
    end

    def check_vertical_squares
      obstructable_squares = []
      if moving_up?
        for y in (opponent_king.row + 1)...piece.row
          obstructable_squares.push([y, piece.column])
        end
      else
        for x in (piece.row + 1)...opponent_king.row
          obstructable_squares.push([y, piece.column])
        end
      end
      return true if valid_obstruction?(obstructable_squares)
      false
    end

    def check_diagonal_squares
      obstructable_squares = []
      if moving_up? && moving_left?
        for x in (opponent_king.column + 1)...piece.column
          for y in (opponent_king.row + 1)...piece.row
            obstructable_squares.push([y, x])
          end
        end
      elsif moving_up?
        for x in (piece.column + 1)...opponent_piece.column
          for y in for y in (opponent_king.row + 1)...piece.row
            obstructable_squares.push([y, x])
          end
        end
      elsif moving_left?
        for x in (opponent_king.column + 1)...piece.column
          for y in (piece.row + 1)...opponent_king.row
            obstructable_squares.push([y, x])
          end
        end
      else
        for x in (piece.column + 1)...opponent_piece.column
          for y in (piece.row + 1)...opponent_king.row
            obstructable_squares.push([y, x])
          end
        end
      end
      return true if valid_obstruction?(obstructable_squares)
      false
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

    def valid_obstruction?(squares)
      squares.each do |square|
        new_square = { row: square[0], column: square[1] }
        opponent_pieces.each do |piece|
          return true if piece.valid_move?(new_square)
        end
      end
      false
    end

    attr_accessor :game, :piece, :new_square
  end
end
