class AddSplitToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :has_split, :boolean
  end
end
