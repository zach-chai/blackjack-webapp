json.array!(@players) do |player|
  json.extract! player, :id, :name, :game_id, :has_turn, :left_turn, :right_turn, :score, :left_score, :right_score
  json.array(player.cards) do |card|
    json.extract! card, :id, :suit, :value, :hidden, :split_hand
  end
  json.url player_url(player, format: :json)
end
