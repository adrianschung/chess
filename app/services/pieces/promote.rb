module Pieces
  class Promote < ApplicationService
    def initialize(piece)
      @piece = piece
      @game = piece.game
    end

    def call
      piece.update_attributes(type: 'Queen')
      Games::UpdateState.call(game)
    end

    private

    attr_accessor :piece, :game
  end
end
