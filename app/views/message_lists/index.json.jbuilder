json.array!(@message_lists) do |message_list|
  json.extract! message_list, :id
  json.url message_list_url(message_list, format: :json)
end
