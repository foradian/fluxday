json.array!(@oauth_applications) do |oauth_application|
  json.extract! oauth_application, :id
  json.url oauth_application_url(oauth_application, format: :json)
end
