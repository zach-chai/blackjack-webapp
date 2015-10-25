class AddGameToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :game, index: true, foreign_key: true
  end
end
