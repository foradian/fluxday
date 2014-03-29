json.array!(@objectives) do |objective|
  json.extract! objective, :id, :name, :user_id, :author_id, :start_date, :end_date
  json.url objective_url(objective, format: :json)
end
