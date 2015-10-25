class Player < ActiveRecord::Base
  include Cardable

  belongs_to :game
  has_many :cards

  def draw_card(card)
    card.update player_id: id, game_id: nil
  end
end
