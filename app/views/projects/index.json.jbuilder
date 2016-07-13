json.array!(@projects) do |project|
  json.extract! project, :id, :name, :description, :user_id, :status, :tenant_id, :remark
  json.url project_url(project, format: :json)
end
