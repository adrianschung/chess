# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queen, type: :model do
  describe 'moving the queen' do
    before(:each) do
      @w_player = FactoryBot.create(:player, playername: 'Wayne')
      @b_player = FactoryBot.create(:player, playername: 'John')
      @game = FactoryBot.create(:game,
                               black_player: @b_player,
                               white_player: @w_player)
      @queen = FactoryBot.create(:queen,
                                game: @game,
                                player: @b_player)
    end

    it 'multiple rows forward' do
      @queen.move_to!(row: 3, column: 4)
      expect(@queen.row).to eq(3)
      expect(@queen.column).to eq(4)
    end

    it 'multiple columns' do
      @queen.move_to!(row: 0, column: 7)
      expect(@queen.row).to eq(0)
      expect(@queen.column).to eq(7)
      end

    it 'multiple squares diagonally' do
      @queen.move_to!(row: 3, column: 7)
      expect(@queen.row).to eq(3)
      expect(@queen.column).to eq(7)
    end

    it 'to an invalid position ' do
      @queen.move_to!(row: 1, column: 6)
      expect(@queen.row).to eq(0)
      expect(@queen.column).to eq(4)
    end
  end
end
