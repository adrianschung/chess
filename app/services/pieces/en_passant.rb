# frozen_string_literal: true

module Pieces
  class EnPassant < ApplicationService
    def initialize(piece, new_square)
      @piece = piece
      @game = piece.game
      @new_square = new_square
    end

    def call
      new_piece = game.pieces.where(type: 'Pawn', column: new_square[:column],
                                    moves: 1).where.not(player_id: piece.player_id).first
      new_piece.update_attributes(column: nil, row: nil, captured: true)
      piece.update_attributes(column: new_square[:column], row: new_square[:row])
      Games::UpdateState.call(game)
    end

    private

    attr_accessor :game, :piece, :new_square
  end
end
