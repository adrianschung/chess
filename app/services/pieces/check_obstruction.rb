module Pieces
  class CheckObstruction < ApplicationService # rubocop:disable Metrics/ClassLength
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
        ((opponent_king.column + 1)...piece.column).each do |x|
          obstructable_squares.push([piece.row, x])
        end
      else
        ((piece.column + 1)...opponent_king.column).each do |x|
          obstructable_squares.push([piece.row, x])
        end
      end
      return true if valid_obstruction?(obstructable_squares)
      false
    end

    def check_vertical_squares
      obstructable_squares = []
      if moving_up?
        ((opponent_king.row + 1)...piece.row).each do |y|
          obstructable_squares.push([y, piece.column])
        end
      else
        ((piece.row + 1)...opponent_king.row).each do |y|
          obstructable_squares.push([y, piece.column])
        end
      end
      return true if valid_obstruction?(obstructable_squares)
      false
    end

    def check_diagonal_squares
      obstructable_squares = []
      if moving_up? && moving_left?
        check_up_and_left
      elsif moving_up?
        check_up_and_right
      elsif moving_left?
        check_down_and_left
      else
        check_down_and_right
      end
      return true if valid_obstruction?(obstructable_squares)
      false
    end

    def moving_up?
      piece.row > opponent_king.row
    end

    def moving_left?
      piece.column > opponent_king.column
    end

    def opponent_king
      piece.opponent_king
    end

    def opponent_pieces
      game.pieces.where.not(player: piece.player, captured: true, type: 'King')
    end

    def valid_obstruction?(squares)
      squares.each do |square|
        new_square = { row: square[0], column: square[1] }
        opponent_pieces.each do |opponent_piece|
          return true if opponent_piece.valid_move?(new_square)
        end
      end
      false
    end

    def check_up_and_left
      obstructable_squares = []
      ((opponent_king.column + 1)...piece.column).each do |x|
        ((opponent_king.row + 1)...piece.row).each do |y|
          obstructable_squares.push([y, x])
        end
      end
    end

    def check_up_and_right
      obstructable_squares = []
      ((piece.column + 1)...opponent_piece.column).each do |x|
        ((opponent_king.row + 1)...piece.row).each do |y|
          obstructable_squares.push([y, x])
        end
      end
    end

    def check_down_and_left
      obstructable_squares = []
      ((opponent_king.column + 1)...piece.column).each do |x|
        ((piece.row + 1)...opponent_king.row).each do |y|
          obstructable_squares.push([y, x])
        end
      end
    end

    def check_down_and_right
      obstructable_squares = []
      ((piece.column + 1)...opponent_piece.column).each do |x|
        ((piece.row + 1)...opponent_king.row).each do |y|
          obstructable_squares.push([y, x])
        end
      end
    end

    attr_accessor :game, :piece, :new_square
  end
end
