class AddHiddenToCards < ActiveRecord::Migration
  def change
    add_column :cards, :hidden, :boolean, default: false
  end
end
