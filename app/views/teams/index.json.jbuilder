json.array!(@teams) do |team|
  json.extract! team, :id, :name, :wins, :losses, :ties, :user_id
  json.url team_url(team, format: :json)
end
