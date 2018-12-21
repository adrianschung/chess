=begin
require 'benchmark'

module Pieces
  module King
    class Castle < ApplicationService
      attr_reader :king, :direction, :player, :game, :rook

      def initialize(king, direction)
        @king = king
        @game = king.game
        @player = king.player
        @direction = direction
        @rook = find_rook
      end

      def call
        return if king.moves != 0 || rook.moves != 0
        return if Pieces::Obstruction.call(king, rook)
        return if direction != 'kingside' && direction != 'queenside'
        king.update_attributes(column: castle_king_column)
        rook.update_attributes(column: castle_rook_column)
        Games::UpdateState.call(@game)
      end

      private

      def find_rook
        column = direction == 'kingside' ? king.column..Float::INFINITY : 0..king.column
        game.pieces.where(type: 'Rook', player: player).find_by(column: column)
      end

      def castle_king_column
        direction == 'kingside' ? 6 : 1
      end

      def castle_rook_column
        direction == 'kingside' ? 5 : 2
      end
    end
  end
end
=end
