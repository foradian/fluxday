json.array!(@work_logs) do |work_log|
  json.extract! work_log, :id, :user_id, :name, :task, :start_time, :end_time, :is_deleted
  json.url work_log_url(work_log, format: :json)
end
