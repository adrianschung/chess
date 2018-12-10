require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe 'Player tries to move piece' do
    player1 = FactoryBot.create(:player, playername: 'Wayne')
    game = FactoryBot.create(:game, white_player: player1)

    it 'will move if the piece is in bounds' do
      piece = FactoryBot.create(:piece, game: game, player: player1)
      piece.move_to!(row: 5, column: 4)
      expect(piece.row).to eq(5)
      expect(piece.column).to eq(4)
    end

    it "will not move if the piece's new column is out of bounds" do
      piece = FactoryBot.create(:piece, game: game, player: player1)
      piece.move_to!(row: 5, column: 9)
      expect(piece.row).to eq(1)
      expect(piece.column).to eq(1)
    end

    it "will not move if the piece's new row is out of bounds" do
      piece = FactoryBot.create(:piece, game: game, player: player1)
      piece.move_to!(row: 9, column: 4)
      expect(piece.row).to eq(1)
      expect(piece.column).to eq(1)
    end
  end

  describe 'A piece checks for obstructions' do
    player1 = FactoryBot.create(:player, playername: 'Wayne')
    game = FactoryBot.create(:game, white_player: player1)

    it 'Should detect vertical obstructions' do
      piece_start = FactoryBot.create(:piece, game: game, column: 2, row: 1, player: player1)
      FactoryBot.create(:piece, game: game, column: 2, row: 2, player: player1)
      obstruction = Pieces::Obstruction.call(piece_start, column: 2, row: 3)
      expect(obstruction).to eq(true)
    end

    it 'Should detect diagnol obstructions down and right' do
      piece_start = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1)
      FactoryBot.create(:piece, game: game, column: 2, row: 2, player: player1)
      obstruction = Pieces::Obstruction.call(piece_start, column: 3, row: 3)
      expect(obstruction).to eq(true)
    end

    it 'Should detect diagnol obstructions up and right' do
      piece_start = FactoryBot.create(:piece, game: game, column: 1, row: 3, player: player1)
      FactoryBot.create(:piece, game: game, column: 2, row: 2, player: player1)
      obstruction = Pieces::Obstruction.call(piece_start, column: 3, row: 1)
      expect(obstruction).to eq(true)
    end

    it 'Should detect horizontal obstructions' do
      piece_start = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1)
      FactoryBot.create(:piece, game: game, column: 2, row: 1, player: player1)
      obstruction = Pieces::Obstruction.call(piece_start, column: 3, row: 1)
      expect(obstruction).to eq(true)
    end
  end

  describe 'Capturing a piece' do
    player1 = FactoryBot.create(:player, playername: 'Wayne')
    player2 = FactoryBot.create(:player, playername: 'Ricky')
    game = FactoryBot.create(:game, white_player: player1, black_player: player2)
    
    it 'Should not move to new location if same colour piece is there' do
      piece_start = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1)
      piece_end = FactoryBot.create(:piece, game: game, column: 3, row: 3, player: player1)
      piece_start.move_to!(row: piece_end.row, column: piece_end.column)
      expect(piece_start.column).to eq(1)
      expect(piece_start.row).to eq(1)
      expect(piece_end.captured).to eq(false)
    end

    it 'Should move to new location and capture opponents piece' do
      player1 = FactoryBot.create(:player, playername: 'Wayne')
      player2 = FactoryBot.create(:player, playername: 'Ricky')
      game = FactoryBot.create(:game, white_player: player1, black_player: player2)
      piece_start = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1)
      piece_end = FactoryBot.create(:piece, game: game, column: 2, row: 2, player: player2)
      piece_start.move_to!(row: piece_end.row, column: piece_end.column)
      expect(piece_start.column).to eq(2)
      expect(piece_start.row).to eq(2)
      piece_end.reload
      expect(piece_end.captured).to eq(true)
    end

    it 'Should move to new location if no other piece is there' do
      piece_start = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1)
      piece_start.move_to!(row: 2, column: 2)
      expect(piece_start.column).to eq(2)
      expect(piece_start.row).to eq(2)
    end

    it 'Should not move to new location if own piece is there' do
      piece_start = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1)
      FactoryBot.create(:piece, game: game, column: 2, row: 2, player: player1)
      piece_start.move_to!(row: 2, column: 2)
      expect(piece_start[:column]).to eq(1)
      expect(piece_start[:row]).to eq(1)
    end
  end

  describe 'piece causing check' do
    player1 = FactoryBot.create(:player, playername: 'white_player')
    player2 = FactoryBot.create(:player, playername: 'black_player')
    game = FactoryBot.create(:game, white_player: player1, black_player: player2)
    king = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1, type: 'King')
    
    it 'will assert that it can be captured' do
      piece1 = FactoryBot.create(:piece, game: game, column: 0, row: 0, player: player1, type: 'Rook')
      piece2 = FactoryBot.create(:piece, game: game, column: 7, row: 0, player: player2, type: 'Rook')
      expect(piece1.can_capture?).to eq(true)
    end

    it 'will assert that it can be obstructed horizontally' do
      king = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1, type: 'King')
      rook = FactoryBot.create(:piece, game: game, column: 3, row: 1, player: player2, type: 'Rook')
      blocker = FactoryBot.create(:piece, game: game, column: 2, row: 2, player: player1, type: 'Rook')
      expect(game.check?(player1)).to eq(true)
      expect(rook.can_obstruct?).to eq(true)
    end

    it 'will assert that it can be obstructed vertically' do
      king = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1, type: 'King')
      rook = FactoryBot.create(:piece, game: game, column: 1, row: 3, player: player2, type: 'Rook')
      blocker = FactoryBot.create(:piece, game: game, column: 2, row: 2, player: player1, type: 'Rook')
      expect(game.check?(player1)).to eq(true)
      expect(rook.can_obstruct?).to eq(true)
    end

    it 'will asser that it can be obstructued diagonally' do
      king = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1, type: 'King')
      queen = FactoryBot.create(:piece, game: game, column: 4, row: 4, player: player2, type: 'Bishop')
      blocker = FactoryBot.create(:piece, game: game, column: 2, row: 3, player: player1, type: 'Rook')
      expect(game.check?(player1)).to eq(true)
      expect(queen.can_obstruct?).to eq(true)
    end
  end
end
