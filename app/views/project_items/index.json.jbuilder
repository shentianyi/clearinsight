json.array!(@project_items) do |project_item|
  json.extract! project_item, :id, :user_id, :tenant_id, :project_id, :rank, :status, :source_id
  json.url project_item_url(project_item, format: :json)
end
