json.array!(@users) do |user|
  json.extract! user, :id, :email, :image, :name, :nickname, :employee_code, :joining_date, :status, :role
  json.url user_url(user, format: :json)
end
