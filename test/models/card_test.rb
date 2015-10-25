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
end
