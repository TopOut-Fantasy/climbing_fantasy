require "application_system_test_case"

class AuthenticationTest < ApplicationSystemTestCase
  test "user can register through the public sign up flow" do
    visit "/register"

    fill_in "Display Name", with: "SummitSeeker"
    fill_in "Email", with: "summitseeker@example.com"
    fill_in "Password", with: "password123456"
    fill_in "Confirm Password", with: "password123456"
    click_button "Create Account"

    assert_current_path("/")
    assert_text "Welcome back, SummitSeeker!"
    assert_button "Sign Out"
  end

  test "admin user can sign in through active admin" do
    visit "/admin/login"

    fill_in "Email", with: admin_users(:super_admin).email
    fill_in "Password", with: "password123456"
    find("input[type='submit']").click

    assert_current_path("/admin")
    assert_text "Upcoming Events"
    assert_text "Stats"
  end
end
