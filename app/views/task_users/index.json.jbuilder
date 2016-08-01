json.array!(@task_users) do |task_user|
  json.extract! task_user, :id, :user_id, :task_id
  json.url task_user_url(task_user, format: :json)
end
