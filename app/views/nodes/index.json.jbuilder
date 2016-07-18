json.array!(@nodes) do |node|
  json.extract! node, :id, :type, :name, :code, :uuid, :devise_code, :is_selected, :node_set_id
  json.url node_url(node, format: :json)
end
