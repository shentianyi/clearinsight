json.array!(@project_users) do |project_user|
  json.extract! project_user, :id, :user_id, :project_id, :tenant_id
  json.url project_user_url(project_user, format: :json)
end
