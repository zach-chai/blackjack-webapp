class AddAliveToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :alive, :integer, default: 0
  end
end
