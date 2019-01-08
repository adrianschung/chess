class RemoveDefaultProfile < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:players, :avatar, nil)
  end
end
