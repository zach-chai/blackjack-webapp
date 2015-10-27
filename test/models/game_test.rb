require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "get player order" do
    game = Game.create
    p1 = game.players.create(name: game.players.size + 1)
    p2 = game.players.create(name: game.players.size + 1)
    p3 = game.players.create(name: game.players.size + 1)
    p4 = game.players.create(name: game.players.size + 1)

    assert_equal p1, game.get_player_ordered(1)
    assert_equal p2, game.get_player_ordered(2)
    assert_equal p3, game.get_player_ordered(3)
    assert_equal p4, game.get_player_ordered(4)
  end
end
