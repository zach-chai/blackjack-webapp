class AddMoreStaysToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :left_stayed, :boolean, default: false
    add_column :players, :right_stayed, :boolean, default: false
  end
end
