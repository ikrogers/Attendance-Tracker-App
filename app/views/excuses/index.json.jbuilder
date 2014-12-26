json.array!(@excuses) do |excuse|
  json.extract! excuse, :id
  json.url excuse_url(excuse, format: :json)
end
