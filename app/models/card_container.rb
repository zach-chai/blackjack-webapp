class CardContainer
  attr_accessor :cards

  def initialize(cards = nil)
    @cards = cards
  end

  def persisted?
    false
  end
end
