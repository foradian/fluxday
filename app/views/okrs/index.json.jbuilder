json.array!(@okrs) do |okr|
  json.extract! okr, :id, :user_id, :name, :start_date, :end_date
  json.url okr_url(okr, format: :json)
end
