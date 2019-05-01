module Pieces
  class Capture < ApplicationService
    def initialize(piece, square)
      @piece = piece
      @game = piece.game
      @square = square
    end

    def call
      new_piece = game.get_piece(square)
      return false if new_piece.player_id == piece.player_id
      piece.update_attributes(column: square[:column], row: square[:row])
      new_piece.update_attributes(row: nil, column: nil, captured: true)
    end

    private

    attr_accessor :game, :piece, :square
  end
end
