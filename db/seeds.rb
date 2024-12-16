# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

# db/seeds.rb

CloudService.create([
    { name: "AWS EC2", provider: "AWS", pricing: 0.08, features: "Scalable, secure, managed service", user_capacity: 10000, supports_sql: true, supports_nosql: true, managed_service: true },
    { name: "Azure VMs", provider: "Azure", pricing: 0.07, features: "Flexible, scalable, and powerful VMs", user_capacity: 8000, supports_sql: true, supports_nosql: false, managed_service: true },
    { name: "Google Compute Engine", provider: "GCP", pricing: 0.06, features: "Custom VM types, global network", user_capacity: 12000, supports_sql: true, supports_nosql: true, managed_service: false },
    { name: "Digital Ocean Droplets", provider: "Digital Ocean", pricing: 0.05, features: "Simple and predictable pricing", user_capacity: 4000, supports_sql: true, supports_nosql: false, managed_service: false },
    { name: "IBM Cloud VMs", provider: "IBM", pricing: 0.09, features: "Hybrid cloud solutions", user_capacity: 7000, supports_sql: true, supports_nosql: true, managed_service: true },
    { name: "Heroku", provider: "Heroku", pricing: 0.10, features: "Easy deployment, managed services", user_capacity: 5000, supports_sql: true, supports_nosql: false, managed_service: true }
  ])
  
  puts "Cloud services seeded!"