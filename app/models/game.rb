class Game < ActiveRecord::Base
  include Cardable

  has_many :players
  has_many :cards

  def load_deck
    for suit in Card::SUITS
      for value in Card::VALUES
        cards.create value: value, suit: suit
      end
    end
    cards
  end
end
