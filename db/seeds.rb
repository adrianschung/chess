player_white = Player.create!(
  email: 'white_player@gmail.com',
  password: 'password',
  playername: 'White_player'
)
player_black = Player.create!(
  email: 'black_player@gmail.com',
  password: 'password',
  playername: 'Black_player'
)

def create_games(player)
  10.times do |n|
    game = Game.create!(name: "Game #{n}", white_player: player)
    game.add_pieces_to_board
  end
end

create_games player_white
create_games player_black
