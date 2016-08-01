json.array!(@pdca_items) do |pdca_item|
  json.extract! pdca_item, :id, :item, :improvement_point, :saving, :remark, :user_id, :type, :status, :start_time, :end_time, :due_time, :taskable_id, :taskable_type
  json.url pdca_item_url(pdca_item, format: :json)
end
