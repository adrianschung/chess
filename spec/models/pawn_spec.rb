# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe 'tries to move' do
    context 'in a valid direction' do
      before(:each) do
        @w_player = FactoryBot.create(:player, playername: 'Wayne')
        @b_player = FactoryBot.create(:player, playername: 'John')
      end
      
      it 'one row forward for white player' do
        game = FactoryBot.create(:game, white_player: @w_player)
        pawn = FactoryBot.create(:pawn,
                                 game: game,
                                 player: @w_player,
                                 row: 1)
        pawn.move_to!(row: 2, column: 1)
        expect(pawn.row).to eq(2)
        expect(pawn.column).to eq(1)
      end

      it 'one row forward for black player' do
        game = FactoryBot.create(:game,
                                 black_player: @b_player,
                                 white_player: @w_player)
        pawn = FactoryBot.create(:pawn,
                                 game: game,
                                 player: @b_player,
                                 row: 6)
        pawn.move_to!(row: 5, column: 1)
        expect(pawn.row).to eq(5)
        expect(pawn.column).to eq(1)
      end

      it 'to capture a piece' do
        game = FactoryBot.create(:game,
                                 white_player: @w_player,
                                 black_player: @b_player)
        pawn = FactoryBot.create(:pawn,
                                         game: game,
                                         player: @b_player)
        FactoryBot.create(:pawn,
                          game: game,
                          row: 6,
                          column: 2,
                          player: @w_player)
        pawn.move_to!(row: 6, column: 2)
        expect(pawn.row).to eq(6)
        expect(pawn.column).to eq(2)
      end

      it 'to en passant' do
        game = FactoryBot.create(:game,
                                 white_player: @w_player,
                                 black_player: @b_player)
        pawn = FactoryBot.create(:pawn,
                                 game: game,
                                 player: @b_player,
                                 row: 3,
                                 column: 3)
        white_pawn = FactoryBot.create(:pawn,
                                       game: game,
                                       row: 3,
                                       column: 2,
                                       player: @w_player,
                                       moves: 1)
        pawn.move_to!(row: 2, column: 2)
        expect(pawn.row).to eq(2)
        expect(pawn.column).to eq(2)
        white_pawn.reload
        expect(white_pawn.captured).to eq(true)
      end

      context 'as the first move' do
        it 'by moving 2 rows' do
          w_player = FactoryBot.create(:player, playername: 'Wayne')
          b_player = FactoryBot.create(:player, playername: 'John')
          game = FactoryBot.create(:game,
                                   white_player: w_player,
                                   black_player: b_player)
          pawn = FactoryBot.create(:pawn, game: game, player: b_player)
          pawn.move_to!(row: 5, column: 1)
          expect(pawn.row).to eq(5)
          expect(pawn.column).to eq(1)
        end
      end
    end

    context 'in an invalid direction' do
      it 'by moving backwards' do
        w_player = FactoryBot.create(:player, playername: 'Wayne')
        b_player = FactoryBot.create(:player, playername: 'John')
        game = FactoryBot.create(:game,
                                 black_player: b_player,
                                 white_player: w_player)
        pawn = FactoryBot.create(:pawn,
                                 game: game,
                                 player: b_player,
                                 row: 6)
        pawn.move_to!(row: 7, column: 1)
        expect(pawn.row).to eq(6)
        expect(pawn.column).to eq(1)
      end

      it 'by moving sideways' do
        w_player = FactoryBot.create(:player, playername: 'Wayne')
        game = FactoryBot.create(:game, white_player: w_player)
        pawn = FactoryBot.create(:pawn, game: game, player: w_player)
        pawn.move_to!(row: 7, column: 2)
        expect(pawn.row).to eq(7)
        expect(pawn.column).to eq(1)
      end

      it 'by moving to an occupied square' do
        w_player = FactoryBot.create(:player, playername: 'Wayne')
        b_player = FactoryBot.create(:player, playername: 'John')
        game = FactoryBot.create(:game,
                                 white_player: w_player,
                                 black_player: b_player)
        pawn_to_move = FactoryBot.create(:pawn,
                                         game: game,
                                         player: b_player)
        FactoryBot.create(:pawn,
                          game: game,
                          row: 6,
                          player: w_player)
        pawn_to_move.move_to!(row: 6, column: 1)
        expect(pawn_to_move.row).to eq(7)
        expect(pawn_to_move.column).to eq(1)
      end

      context 'after the first move' do
        it 'by moving 2 rows' do
          w_player = FactoryBot.create(:player, playername: 'Wayne')
          b_player = FactoryBot.create(:player, playername: 'John')
          game = FactoryBot.create(:game,
                                   white_player: w_player,
                                   black_player: b_player)
          pawn = FactoryBot.create(:pawn, game: game, player: b_player)
          pawn.move_to!(row: 6, column: 1)
          pawn.move_to!(row: 4, column: 1)
          expect(pawn.row).to eq(6)
          expect(pawn.column).to eq(1)
        end
      end
    end

    it 'should promote correctly for white player' do
      w_player = FactoryBot.create(:player, playername: 'Wayne')
      b_player = FactoryBot.create(:player, playername: 'John')
      game = FactoryBot.create(:game,
                               white_player: w_player,
                               black_player: b_player)
      pawn = FactoryBot.create(:pawn,
                               game: game,
                               player: w_player,
                               row: 6,
                               column: 0)
      pawn.move_to!(row: 7, column: 0)
      expect(pawn.row).to eq(7)
      expect(pawn.type). to eq('Queen')
    end

    it 'should promote correctly for black player' do
      w_player = FactoryBot.create(:player, playername: 'Wayne')
      b_player = FactoryBot.create(:player, playername: 'John')
      game = FactoryBot.create(:game,
                               white_player: w_player,
                               black_player: b_player)
      pawn = FactoryBot.create(:pawn,
                               game: game,
                               player: b_player,
                               row: 1,
                               column: 0)
      pawn.move_to!(row: 0, column: 0)
      expect(pawn.row).to eq(0)
      expect(pawn.type). to eq('Queen')
    end
  end
end
