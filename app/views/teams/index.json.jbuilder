json.array!(@teams) do |team|
  json.extract! team, :id, :name, :code, :description, :project_id, :members_count, :managers_count, :is_deleted, :pending_tasks, :status
  json.url team_url(team, format: :json)
end
