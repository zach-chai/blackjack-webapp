class Card
  attr_accessor :suit, :value

  def initialize(value, suit)
    @suit = suit
    @value = value
  end

  def persisted?
    false
  end
end
