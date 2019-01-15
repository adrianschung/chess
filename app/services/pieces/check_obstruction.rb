module Pieces
  class CheckObstruction < ApplicationService
    def initialize(piece, new_square)
      @piece = piece
      @game = piece.game
      @new_square = new_square
    end

    def call
      return check_horizontal_squares if piece.row == opp_king.row
      return check_vertical_squares if piece.column == opp_king.column
      return check_diagonal_squares if (piece.row - opp_king.row).abs ==
                                       (piece.column - opp_king.column).abs
    end

    private
    
    def check_horizontal_squares
      obstructable_squares = []
      if moving_left?
        ((opp_king.column + 1)...piece.column).each do |x|
          obstructable_squares.push([piece.row, x])
        end
      else
        ((piece.column + 1)...opp_king.column).each do |x|
          obstructable_squares.push([piece.row, x])
        end
      end
      return true if valid_obstruction?(obstructable_squares)
      false
    end

    def check_vertical_squares
      obstructable_squares = []
      if moving_up?
        ((opp_king.row + 1)...piece.row).each do |y|
          obstructable_squares.push([y, piece.column])
        end
      else
        ((piece.row + 1)...opp_king.row).each do |y|
          obstructable_squares.push([y, piece.column])
        end
      end
      return true if valid_obstruction?(obstructable_squares)
      false
    end

    def check_diagonal_squares
      squares = if moving_up? && moving_left?
                  check_diagonal(opp_king.column, piece.column, opp_king.row, piece.row)
                elsif moving_up?
                  check_diagonal(piece.column, opp_king.column, opp_king.row, piece.row)
                elsif moving_left?
                  check_diagonal(opp_king.column, piece.column, piece.row, opp_king.row)
                else
                  check_diagonal(piece.column, opp_king.column, piece.row, opp_king.row)
                end
      valid_obstruction?(squares) ? true : false
    end

    def moving_up?
      piece.row > opp_king.row
    end

    def moving_left?
      piece.column > opp_king.column
    end

    def opp_king
      piece.opponent_king
    end

    def opp_pieces
      game.pieces.where.not(player: piece.player, captured: true, type: 'King')
    end

    def valid_obstruction?(squares)
      squares.each do |square|
        new_square = { row: square[0], column: square[1] }
        opp_pieces.each do |opp_piece|
          return true if opp_piece.valid_move?(new_square)
        end
      end
      false
    end

    def check_diagonal(column1, column2, row1, row2)
      obstructable_squares = []
      ((column1 + 1)...column2).each do |x|
        ((row1 + 1)...row2).each do |y|
          obstructable_squares.push([y, x])
        end
      end
      obstructable_squares
    end

    attr_accessor :game, :piece, :new_square
  end
end
