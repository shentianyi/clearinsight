json.array!(@kpis) do |kpi|
  json.extract! kpi, :id, :name, :code, :description, :round, :direction, :unit, :unit_string, :formula_text, :is_system
  json.url kpi_url(kpi, format: :json)
end
