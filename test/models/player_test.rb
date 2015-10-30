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
    player.draw_card(Card.random(game.id).first, {hidden: true, split_hand: "left"})
    assert_equal 1, player.cards.where(hidden: true).size
    assert_equal 1, player.cards.where(split_hand: "left").size
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
    player.cards.create
    player.cards.create
    assert_equal nil, player.has_split
    player.split
    assert_equal true, player.has_split
    assert_equal 2, player.cards.where(hidden: false).size
  end

  test "end turn" do
    player = Player.create has_turn: true, left_turn: true, right_turn: true
    player.end_turn "left"
    assert_equal false, player.left_turn
    player.end_turn "right"
    assert_equal false, player.right_turn
    player.end_turn
    assert_equal false, player.has_turn
  end

  test "hand value" do
    player = Player.create
    player.cards.create value: "Five"
    player.cards.create value: "Ace"
    assert_equal 15, player.hand_value
  end

  test "has ace" do
    player = Player.create
    player.cards.create value: "Ace"
    player.cards.create value: "Five"
    assert player.has_ace?
    player.cards.delete_all
    player.cards.create value: "Five"
    player.cards.create value: "King"
    assert_equal false, player.has_ace?
  end
end
