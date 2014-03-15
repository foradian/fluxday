json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :description, :start_date, :end_date, :project_id, :team_id, :user_id, :tracker_id, :comments_count
  json.url task_url(task, format: :json)
end
