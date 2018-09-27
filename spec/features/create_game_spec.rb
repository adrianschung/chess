require 'rails_helper'
require 'support/sign_in'

Capybara.automatic_reload = false
Capybara.default_max_wait_time = 10

describe 'A player creates a game', feature: true, js: true do
  scenario 'A player creates a game with a valid user' do
    player = FactoryBot.create(:player, playername: 'Wayne')
    FactoryBot.create(:game, white_player: player)
    sign_in(player)

    find('#create_game_dropdown').click
    fill_in('name', with: 'game123')
    click_button('create!')

    expect(page).to have_content('game123')

    find('#my_games_dropdown').click
  end
end
