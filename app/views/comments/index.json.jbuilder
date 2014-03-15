json.array!(@comments) do |comment|
  json.extract! comment, :id, :source_id, :source_type, :body, :user_id
  json.url comment_url(comment, format: :json)
end
