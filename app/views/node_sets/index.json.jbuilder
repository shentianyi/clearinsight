json.array!(@node_sets) do |node_set|
  json.extract! node_set, :id, :diagram_id
  json.url node_set_url(node_set, format: :json)
end
