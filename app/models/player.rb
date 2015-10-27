class Player < ActiveRecord::Base
  include Cardable

  belongs_to :game
  has_many :cards

  def draw_card(card)
    card.update player_id: id, game_id: nil
  end

  def begin_turn
    self.has_turn = true
    save
  end

  def end_turn
    self.has_turn = false
    save
  end

  def split
    self.has_split = true
    save
  end
end
