json.array!(@plans) do |plan|
  json.extract! plan, :id, :title, :content, :remark, :user_id, :type, :status, :start_time, :end_time, :due_time, :taskable_id, :taskable_type
  json.url plan_url(plan, format: :json)
end
