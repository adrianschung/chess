require 'rails_helper'
require 'support/sign_in'

#describe 'castle the king' do
#  scenario 'white player queenside' do
#    white_player = FactoryBot.create(:player, playername: 'Carl')
#    black_player = FactoryBot.create(:player, playername: 'Steve')
#    game = FactoryBot.create(:game, white_player: white_player,
#                                    black_player: black_player,
#                                    name: 'game1')
#    rook = FactoryBot.create(:piece, game: game,
#                                     player: white_player,
#                                     type: 'Rook',
#                                     row: 0,
#                                     column: 0)
#    king = FactoryBot.create(:piece, game: game,
#                                     player: white_player,
#                                     type: 'King',
#                                     row: 0,
#                                     column: 4)
#    sign_in(black_player)
#    sign_in(white_player)

#    visit game_path(game)
#    click_button('Castle Queenside')
#    king.reload
#    rook.reload
#    game.reload

#    visit game_path(game)
#    expect(king.column).to eq(1)
#    expect(rook.column).to eq(2)
#    expect(page).to have_content("Black's Turn")
#  end

  #
  # scenario 'white player kingside' do
  #   rook = FactoryBot.create(:piece, game: game,
  #                                    player: white_player,
  #                                    type: 'Rook',
  #                                    row: 0,
  #                                    column: 7)
  #   king = FactoryBot.create(:piece, game: game,
  #                                    player: white_player,
  #                                    type: 'King',
  #                                    row: 0,
  #                                    column: 4)
  #   game.update_attributes(state: 1)
  #   visit game_path(game)
  #   expect(page).to have_button('Castle Kingside')
  # end
  #
  # scenario 'black player queenside' do
  #   rook = FactoryBot.create(:piece, game: game,
  #                                    player: white_player,
  #                                    type: 'Rook',
  #                                    row: 7,
  #                                    column: 0)
  #   king = FactoryBot.create(:piece, game: game,
  #                                    player: white_player,
  #                                    type: 'King',
  #                                    row: 7,
  #                                    column: 4)
  #   game.update_attributes(state: 2)
  #   visit game_path(game)
  #   expect(page).to have_button('Castle Kingside')
  # end
  #
  # scenario 'black player kingside' do
  #   rook = FactoryBot.create(:piece, game: game,
  #                                    player: white_player,
  #                                    type: 'Rook',
  #                                    row: 7,
  #                                    column: 7)
  #   king = FactoryBot.create(:piece, game: game,
  #                                    player: white_player,
  #                                    type: 'King',
  #                                    row: 7,
  #                                    column: 4)
  #   game.update_attributes(state: 2)
  #   visit game_path(game)
  #   expect(page).to have_button('Castle Kingside')
  #
  # end
  #
  # scenario 'cannot castle queenside if rook or king have been moved' do
  #   rook = FactoryBot.create(:piece, game: game,
  #                                    player: white_player,
  #                                    type: 'Rook',
  #                                    row: 7,
  #                                    column: 7)
  #   king = FactoryBot.create(:piece, game: game,
  #                                    player: white_player,
  #                                    type: 'King',
  #                                    row: 7,
  #                                    column: 4)
  # end
  #
  # scenario 'cannot castle kingside if rook or king have been moved' do
  #   rook = FactoryBot.create(:piece, game: game,
  #                                    player: white_player,
  #                                    type: 'Rook',
  #                                    row: 7,
  #                                    column: 7)
  #   king = FactoryBot.create(:piece, game: game,
  #                                    player: white_player,
  #                                    type: 'King',
  #                                    row: 7,
  #                                    column: 4)
  # end
#end
