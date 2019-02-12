module Pieces
  class Promote < ApplicationService
    def initialize(piece)
      @piece = piece
    end

    def call
      piece.update_attributes(type: 'Queen')
    end

    private

    attr_accessor :piece
  end
end
