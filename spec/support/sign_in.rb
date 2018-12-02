def sign_in(player)
  login_as(player, scope: :player)
  visit games_path
  find('#sidebar').click
end
