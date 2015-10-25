class Card < ActiveRecord::Base
  SUITS = ["Clubs", "Spades", "Diamonds", "Hearts"]
  VALUES = ["Two", "Three", "Four", "Five", "Six", "Seven",
    "Eight", "Nine", "Ten", "Jack", "Queen", "King", "Ace"]

  scope :random, ->(game_id) { where(game_id: game_id).order('RANDOM()').limit(1) }

  belongs_to :player
  belongs_to :game

  def ==(o)
    o.class == self.class && o.suit == suit && o.value == value
  end
end
