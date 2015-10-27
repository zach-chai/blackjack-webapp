require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "has cards" do
    player = Player.create
    player.cards.create

    assert_equal player.cards.size, 1
  end

  test "draw card" do
    player = Player.create
    game = Game.create
    game.load_deck

    player.draw_card Card.random(game.id).first
    assert_equal player.cards.size, 1
  end

  test "has turn" do
    player = Player.create
    assert_equal player.has_turn, false
    player.begin_turn
    assert_equal player.has_turn, true
    player.end_turn
    assert_equal player.has_turn, false
  end

  test "split" do
    player = Player.create
    assert_equal nil, player.has_split
    player.split
    assert_equal true, player.has_split
  end
end
