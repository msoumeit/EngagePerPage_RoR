json.array!(@games) do |game|
  json.extract! game, :id, :name, :expirationdate
  json.url game_url(game, format: :json)
end
