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

  def end_turn(split = nil, stay = false)
    case split
    when "left"
      self.left_turn = false
      self.left_stayed = stay
    when "right"
      self.right_turn = false
      self.right_stayed = stay
    else
      self.has_turn = false
      self.stayed = stay
    end
    if self.left_turn == false && self.right_turn == false
      self.has_turn = false
      self.stayed = self.left_stayed && self.right_stayed
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

  def hand_value(visible_only = false)
    self.reload
    value = 0
    cards.each do |card|
      if !card.hidden || !visible_only
        value = value + card.score
      end
    end
    num_aces.times do |i|
      if value > 21
        value -= 10
      end
    end
    value
  end

  def split_value(split_hand)
    self.reload
    value = 0
    cards.each do |card|
      value = value + card.score if card.split_hand == split_hand
    end
    num_aces.times do |i|
      if value > 21
        value -= 10
      end
    end
    value
  end

  def has_ace?
    cards.map(&:value).include? "Ace"
  end

  def num_aces
    aces = 0
    cards.map(&:value).each do |value|
      if value == "Ace"
        aces += 1
      end
    end
    aces
  end

  def calculate_score!
    self.reload
    if has_split
      self.update left_score: split_value("left"), right_score: split_value("right")
    else
      self.score = hand_value
    end
    save
  end

  def has_charlie?
    (cards.size == 7 && hand_value <= 21)
  end
end
