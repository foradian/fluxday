# Load the Rails application.
require File.expand_path('../application', __FILE__)
require './lib/time_to_diff.rb'
begin
  AppConfig = YAML.load_file("#{::Rails.root}/config/app_config.yml")[::Rails.env]
rescue Errno::ENOENT
  AppConfig = YAML.load_file("#{::Rails.root}/config/app_config.yml.example")[::Rails.env]
end
# Initialize the Rails application.
Fluxday::Application.initialize!
