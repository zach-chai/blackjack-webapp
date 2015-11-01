class AddHumanToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :human, :boolean, default: true
  end
end
