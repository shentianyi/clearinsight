json.array!(@records) do |record|
  json.extract! record, :id, :user_id, :tenant_id, :recordable_id, :recordable_type, :action, :logable_id, :logable_type
  json.url record_url(record, format: :json)
end
