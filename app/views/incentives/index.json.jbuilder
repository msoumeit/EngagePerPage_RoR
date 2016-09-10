json.array!(@incentives) do |incentive|
  json.extract! incentive, :id, :title, :code, :expirydate
  json.url incentive_url(incentive, format: :json)
end
