json.array!(@projects) do |project|
  json.extract! project, :id, :name, :code, :description, :is_deleted
  json.url project_url(project, format: :json)
end
