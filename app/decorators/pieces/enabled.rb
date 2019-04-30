module Pieces
  class Enabled < ApplicationService
    attr_accessor :piece, :game

    def initialize(piece)
      @piece = piece
      @game = piece.game
    end

    def call
      return true if game.state == "White's Turn" && piece.color == 'White'
      return true if game.state == "Black's Turn" && piece.color == 'Black'
    end
  end
end
