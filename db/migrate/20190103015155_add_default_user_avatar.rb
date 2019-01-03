class AddDefaultUserAvatar < ActiveRecord::Migration[5.0]
  def change
    remove_column :players, :avatar, :string
    add_column :players, :avatar, :string, default: 'profile.png'
  end
end
