require "test_helper"

class AdminUserTest < ActiveSupport::TestCase
  test "validates presence of role" do
    user = AdminUser.new(email: "test@example.com", password: "password123456", role: nil)
    assert_not user.valid?
    assert_includes user.errors[:role], "can't be blank"
  end

  test "role enum values" do
    assert_equal %w[viewer admin super_admin], AdminUser.roles.keys
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
