class AddStayedToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :stayed, :boolean, default: false
  end
end
