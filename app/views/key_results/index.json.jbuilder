json.array!(@key_results) do |key_result|
  json.extract! key_result, :id, :name, :user_id, :objective_id, :author_id, :start_date, :end_date
  json.url key_result_url(key_result, format: :json)
end
