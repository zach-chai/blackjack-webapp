class Player < ActiveRecord::Base
  include Cardable

  belongs_to :game
  has_many :cards

  def draw_card(card, options = {})
    hidden = options[:hidden] || false
    split_hand = options[:split_hand] || nil
    card.update player_id: id, game_id: nil, hidden: hidden, split_hand: split_hand
  end

  def begin_turn
    if has_split == true
      self.left_turn = true
      self.right_turn = true
    end
    self.has_turn = true
    save
  end

  def end_turn(split = nil)
    case split
    when "left"
      self.left_turn = false
    when "right"
      self.right_turn = false
    else
      self.has_turn = false
    end
    if self.left_turn == false && self.right_turn == false
      self.has_turn = false
    end
    save
  end

  def split
    cards.update_all hidden: false
    cards.first.update split_hand: "left"
    cards.where(split_hand: nil).first.update split_hand: "right"
    self.has_split = true
    self.left_turn = false
    self.right_turn = false
    save
  end

  def hand_value
    value = 0
    cards.each do |card|
      value = value + card.score
    end
    value
  end
  def has_ace?
    cards.map(&:value).include? "Ace"
  end
end
