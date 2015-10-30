require 'test_helper'

class CardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'random card from game' do
    game = Game.create
    game.load_deck

    assert Card.random(game.id).size, 1
  end

  test 'score' do
    card = Card.create value: "Jack"
    assert_equal 10, card.score
    card = Card.create value: "Six"
    assert_equal 6, card.score
  end
end
