class AddUniqueToPlayername < ActiveRecord::Migration[5.0]
  def change
    change_column :players, :playername, :string, unique: true
  end
end
