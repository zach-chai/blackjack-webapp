class AddSplitScoresToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :left_score, :integer
    add_column :players, :right_score, :integer
  end
end
