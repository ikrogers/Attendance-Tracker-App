json.array!(@attendance_policies) do |attendance_policy|
  json.extract! attendance_policy, :id
  json.url attendance_policy_url(attendance_policy, format: :json)
end
