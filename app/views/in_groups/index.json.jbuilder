json.array!(@in_groups) do |in_group|
  json.extract! in_group, :id
  json.url in_group_url(in_group, format: :json)
end
