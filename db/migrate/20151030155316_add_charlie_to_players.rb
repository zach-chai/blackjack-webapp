class AddCharlieToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :charlie, :boolean
  end
end
