require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "has cards" do
    player = Player.create
    player.cards.create

    assert player.cards.size, 1
  end

  test "draw card" do
    player = Player.create
    game = Game.create
    game.load_deck

    player.draw_card Card.random(game.id).first
  end
end
