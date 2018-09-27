module Pieces
  class Obstruction < ApplicationService
    def initialize(piece, new_square)
      @piece = piece
      @game = piece.game
      @new_square = new_square
      @current_column = piece[:column]
      @current_row = piece[:row]
      @new_column = new_square[:column]
      @new_row = new_square[:row]
    end

    def call
      return horizontal_obstruction if current_row == new_row
      return vertical_obstruction if current_column == new_column
      return diagonal_obstruction if (current_column - new_column).abs ==
                                     (current_row - new_row).abs
      nil
    end

    private

    attr_accessor :game, :piece, :current_row, :current_column, :new_row, :new_column

    def column_start
      [current_column, new_column].min + 1
    end

    def row_start
      [current_row, new_row].min + 1
    end

    def column_end
      [current_column, new_column].max
    end

    def row_end
      [current_row, new_row].max
    end

    def horizontal_obstruction
      (column_start...column_end).each do |column|
        return true if game.square_occupied?(row: current_row, column: column)
      end
      false
    end

    def vertical_obstruction
      (row_start...row_end).each do |row|
        return true if game.square_occupied?(row: row, column: current_column)
      end
      false
    end

    def diagonal_obstruction
      # diagonal going down and right or going up and going left
      if down_right == true
        (row_start...row_end).each do |row|
          column = column_start + (row - row_start)
          return true if game.square_occupied?(row: row, column: column)
        end
      # diagonal going down and left or up and right
      else
        (row_start...row_end).each do |row|
          column = column_end - 1 + (row_start - row)
          return true if game.square_occupied?(row: row, column: column)
        end
      end
      false
    end

    def down_right
      return true if current_column < new_column && current_row < new_row
      return true if current_column > new_column && current_row > new_row
      false
    end
  end
end
