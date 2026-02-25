# Create super_admin account
AdminUser.find_or_create_by!(email: "admin@climbingfantasy.com") do |user|
  user.password = "password123456"
  user.password_confirmation = "password123456"
  user.role = :super_admin
end

puts "Seeded AdminUser: admin@climbingfantasy.com (super_admin)"
