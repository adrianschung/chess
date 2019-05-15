Warden::Manager.after_set_user do |player, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = player.id
end

Warden::Manager.before_logout do |_player, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = nil
end
