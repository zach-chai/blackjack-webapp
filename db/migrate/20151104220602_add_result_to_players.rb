class AddResultToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :result, :string
    add_column :players, :rank, :integer
  end
end
