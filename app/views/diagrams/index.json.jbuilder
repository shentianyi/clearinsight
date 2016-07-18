json.array!(@diagrams) do |diagram|
  json.extract! diagram, :id, :name, :diagrammable_id, :diagrammable_type, :layout, :tenant_id
  json.url diagram_url(diagram, format: :json)
end
