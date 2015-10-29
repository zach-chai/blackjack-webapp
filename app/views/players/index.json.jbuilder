json.array!(@players) do |player|
  json.extract! player, :id, :name, :game_id, :has_turn, :left_turn, :right_turn
  json.url player_url(player, format: :json)
end
