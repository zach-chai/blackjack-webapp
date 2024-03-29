class Game < ActiveRecord::Base
  include Cardable
  PLAYERS = 3

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

  def get_player_ordered num
    players.where(name: "#{num}").first
  end
end
