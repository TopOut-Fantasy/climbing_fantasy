require "test_helper"

class AdminUserTest < ActiveSupport::TestCase
  test "validates presence of role" do
    user = AdminUser.new(email: "test@example.com", password: "password123456", role: nil)
    assert_not user.valid?
    assert_includes user.errors[:role], "can't be blank"
  end

  test "role enum values" do
    assert_equal ["viewer", "admin", "super_admin"], AdminUser.roles.keys
  end

  test "default role is viewer" do
    user = AdminUser.new(email: "test@example.com", password: "password123456")
    assert_equal "viewer", user.role
  end

  test "super_admin fixture" do
    admin = admin_users(:super_admin)
    assert admin.super_admin?
    assert_equal "admin@climbingfantasy.com", admin.email
  end
end

# == Schema Information
#
# Table name: admin_users
#
#  id                     :bigint           not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("viewer"), not null
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email                 (email) UNIQUE
#  index_admin_users_on_reset_password_token  (reset_password_token) UNIQUE
#
