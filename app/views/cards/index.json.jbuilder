json.array!(@cards) do |card|
  json.extract! card, :id, :suit, :value
  json.url card_url(card, format: :json)
end
