class AddSplitHandToCards < ActiveRecord::Migration
  def change
    add_column :cards, :split_hand, :string
  end
end
