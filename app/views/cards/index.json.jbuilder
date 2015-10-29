json.array!(@cards) do |card|
  json.extract! card, :id, :suit, :value, :hidden, :split_hand
  json.url card_url(card, format: :json)
end
