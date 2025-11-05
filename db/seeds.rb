# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

api_key = ApiKey.find_or_create_by!(name: "Development Key") do |key|
  key.active = true
end
puts "API Key: #{api_key.token}"
puts "(Use this in X-API-Key header for API requests)"
