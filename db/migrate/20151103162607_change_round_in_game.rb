class ChangeRoundInGame < ActiveRecord::Migration
  def change
    change_column :games, :round, :integer, default: 0
  end
end
