require 'rails_helper'

RSpec.describe Rook, type: :model do
  player = FactoryBot.create(:player, playername: 'Wayne')
  game = FactoryBot.create(:game, white_player: player)
  rook = FactoryBot.create(:rook, game: game, player: player)

  describe 'tries to move' do
    it 'will not move diagonal' do
      rook.move_to!(row: 5, column: 5)
      expect(rook.row).to eq(7)
      expect(rook.column).to eq(7)
    end

    it 'Moves to a new row' do
      rook = FactoryBot.create(:rook, game: game, player: player)
      rook.move_to!(row: 0, column: 7)
      expect(rook.row).to eq(0)
      expect(rook.column).to eq(7)
    end

    it 'Moves to a new column' do
      rook = FactoryBot.create(:rook, game: game, player: player)
      rook.move_to!(row: 7, column: 0)
      expect(rook.row).to eq(7)
      expect(rook.column).to eq(0)
    end
  end
end
