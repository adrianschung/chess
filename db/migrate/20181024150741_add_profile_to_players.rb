class AddProfileToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :country, :string
    add_column :players, :birthyear, :date
  end
end
