module Games
  class RenderChessboard < ApplicationService
    attr_reader :pieces

    def initialize(pieces)
      @pieces = pieces
    end

    # builds grid with pieces to be rendered in view
    def call
      grid = []
      (0..7).each do |row|
        grid_row = []
        (0..7).each do |col|
          space = pieces.select { |piece| piece.row == row && piece.column == col }
          grid_row << space.first
        end
        grid << grid_row
      end
      grid
    end
  end
end
