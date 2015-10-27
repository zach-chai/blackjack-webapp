class AddMoreTurnsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :left_turn, :boolean
    add_column :players, :right_turn, :boolean
  end
end
