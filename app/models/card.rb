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

  def score
    case value
    when "Two"
      2
    when "Three"
      3
    when "Four"
      4
    when "Five"
      5
    when "Six"
      6
    when "Seven"
      7
    when "Eight"
      8
    when "Nine"
      9
    when "Ten", "Jack", "Queen", "King", "Ace"
      10
    else
      0
    end
  end

  def to_s
    "#{value} of #{suit}"
  end
end
