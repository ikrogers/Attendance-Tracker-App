json.array!(@excused_users) do |excused_user|
  json.extract! excused_user, :id
  json.url excused_user_url(excused_user, format: :json)
end
