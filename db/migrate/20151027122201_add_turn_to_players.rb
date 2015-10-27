class AddTurnToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :has_turn, :boolean, default: false
  end
end
