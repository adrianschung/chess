require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe 'Player tries to move piece' do
    before(:each) do
      @player1 = FactoryBot.create(:player, playername: 'Wayne')
      @game = FactoryBot.create(:game, white_player: @player1, state: "White's Turn")
      @piece = FactoryBot.create(:piece, game: @game, column: 2, row: 2, player: @player1)
    end

    it 'will move if the piece is in bounds' do
      @piece.move_to!(row: 5, column: 4)
      expect(@piece.row).to eq(5)
      expect(@piece.column).to eq(4)
      expect(@game.state).to eq("Black's Turn")
    end

    it "will not move if the piece's new column is out of bounds" do
      @piece.move_to!(row: 5, column: 9)
      expect(@piece.row).to eq(2)
      expect(@piece.column).to eq(2)
      expect(@game.state).to eq("White's Turn")
    end

    it "will not move if the piece's new row is out of bounds" do
      @piece.move_to!(row: 9, column: 4)
      expect(@piece.row).to eq(2)
      expect(@piece.column).to eq(2)
      expect(@game.state).to eq("White's Turn")
    end

    it 'Should detect vertical obstructions' do
      FactoryBot.create(:piece, game: @game, column: 2, row: 3, player: @player1)
      obstruction = Pieces::Obstruction.call(@piece, column: 2, row: 4)
      expect(obstruction).to eq(true)
    end

    it 'Should detect diagonal obstructions down and right' do
      FactoryBot.create(:piece, game: @game, column: 3, row: 3, player: @player1)
      obstruction = Pieces::Obstruction.call(@piece, column: 4, row: 4)
      expect(obstruction).to eq(true)
    end

    it 'Should detect diagonal obstructions up and right' do
      FactoryBot.create(:piece, game: @game, column: 1, row: 1, player: @player1)
      obstruction = Pieces::Obstruction.call(@piece, column: 0, row: 0)
      expect(obstruction).to eq(true)
    end

    it 'Should detect horizontal obstructions' do
      FactoryBot.create(:piece, game: @game, column: 3, row: 2, player: @player1)
      obstruction = Pieces::Obstruction.call(@piece, column: 4, row: 2)
      expect(obstruction).to eq(true)
    end
  end

  describe 'Capturing a piece' do
    before(:each) do
      @player1 = FactoryBot.create(:player, playername: 'Wayne')
      @player2 = FactoryBot.create(:player, playername: 'Ricky')
      @game = FactoryBot.create(:game, white_player: @player1, black_player: @player2, state: "White's Turn")
    end

    it 'Should not move to new location if same colour piece is there' do
      piece_start = FactoryBot.create(:piece, game: @game, column: 1, row: 1, player: @player1)
      piece_end = FactoryBot.create(:piece, game: @game, column: 3, row: 3, player: @player1)
      piece_start.move_to!(row: piece_end.row, column: piece_end.column)
      expect(piece_start.column).to eq(1)
      expect(piece_start.row).to eq(1)
      expect(piece_end.captured).to eq(false)
      expect(@game.state).to eq("White's Turn")
    end

    it 'Should move to new location and capture opponents piece' do
      piece_start = FactoryBot.create(:piece, game: @game, column: 1, row: 1, player: @player1)
      piece_end = FactoryBot.create(:piece, game: @game, column: 2, row: 2, player: @player2)
      piece_start.move_to!(row: piece_end.row, column: piece_end.column)
      expect(piece_start.column).to eq(2)
      expect(piece_start.row).to eq(2)
      piece_end.reload
      expect(piece_end.captured).to eq(true)
      expect(@game.state).to eq("Black's Turn")
    end

    it 'Should move to new location if no other piece is there' do
      piece_start = FactoryBot.create(:piece, game: @game, column: 1, row: 1, player: @player1)
      piece_start.move_to!(row: 2, column: 2)
      expect(piece_start.column).to eq(2)
      expect(piece_start.row).to eq(2)
      expect(@game.state).to eq("Black's Turn")
    end
  end

  describe 'piece causing check' do
    player1 = FactoryBot.create(:player, playername: 'white_player')
    player2 = FactoryBot.create(:player, playername: 'black_player')
    game = FactoryBot.create(:game, white_player: player1, black_player: player2)
    king = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1, type: 'King')

    it 'will assert that it can be captured' do
      piece1 = FactoryBot.create(:piece, game: game, column: 0, row: 0,
                                         player: player1, type: 'Rook')
      FactoryBot.create(:piece, game: game, column: 7, row: 0, player: player2, type: 'Rook')
      expect(piece1.can_capture?).to eq(true)
    end

    it 'will assert that it can be obstructed horizontally' do
      king = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1, type: 'King')
      rook = FactoryBot.create(:piece, game: game, column: 3, row: 1, player: player2, type: 'Rook')
      FactoryBot.create(:piece, game: game, column: 2, row: 2, player: player1, type: 'Rook')
      expect(game.check?(player1)).to eq(true)
      expect(rook.can_obstruct?).to eq(true)
    end

    it 'will assert that it can be obstructed vertically' do
      king = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1, type: 'King')
      rook = FactoryBot.create(:piece, game: game, column: 1, row: 3, player: player2, type: 'Rook')
      FactoryBot.create(:piece, game: game, column: 2, row: 2, player: player1, type: 'Rook')
      expect(game.check?(player1)).to eq(true)
      expect(rook.can_obstruct?).to eq(true)
    end

    it 'will asser that it can be obstructued diagonally' do
      king = FactoryBot.create(:piece, game: game, column: 1, row: 1, player: player1, type: 'King')
      queen = FactoryBot.create(:piece, game: game, column: 4, row: 4,
                                        player: player2, type: 'Bishop')
      FactoryBot.create(:piece, game: game, column: 2, row: 3, player: player1, type: 'Rook')
      expect(game.check?(player1)).to eq(true)
      expect(queen.can_obstruct?).to eq(true)
    end
  end
end
