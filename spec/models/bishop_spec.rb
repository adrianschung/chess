require 'rails_helper'

RSpec.describe Bishop, type: :model do
  describe 'a player wants to move his bishop' do
    before(:each) do
      @player = FactoryBot.create(:player, playername: 'Wayne')
      @game = FactoryBot.create(:game, white_player: @player, state:"White's Turn")
      @bishop = FactoryBot.create(:bishop, game: @game, player: @player)
    end

    it 'does not allow the bishop to move in only horizontal direction' do
      @bishop.move_to!(row: 1, column: 5)
      expect(@bishop.row).to eq(1)
      expect(@bishop.column).to eq(7)
      expect(@game.state).to eq("White's Turn")
    end

    it 'does not allow the bishop to move in only vertical direction' do
      @bishop.move_to!(row: 3, column: 7)
      expect(@bishop.row).to eq(1)
      expect(@bishop.column).to eq(7)
      expect(@game.state).to eq("White's Turn")
    end

    it 'allows the bishop to move in the correct diagonal direction' do
      @bishop.move_to!(row: 2, column: 6)
      expect(@bishop.row).to eq(2)
      expect(@bishop.column).to eq(6)
      expect(@game.state).to eq("Black's Turn")
    end
  end
end
