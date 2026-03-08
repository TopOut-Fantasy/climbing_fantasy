require "test_helper"

module Users
  class RegistrationsControllerTest < ActionDispatch::IntegrationTest
    test "GET /register renders registration page" do
      get "/register"
      assert_response :success
      assert_select "h2", "Create Account"
    end

    test "POST registration creates user with valid params" do
      assert_difference("User.count", 1) do
        post user_registration_path, params: {
          user: {
            email: "newuser@example.com",
            password: "password123456",
            password_confirmation: "password123456",
            display_name: "NewClimber",
          },
        }
      end
      assert_redirected_to authenticated_root_path
    end

    test "POST registration with missing display_name shows errors" do
      assert_no_difference("User.count") do
        post user_registration_path, params: {
          user: {
            email: "newuser@example.com",
            password: "password123456",
            password_confirmation: "password123456",
            display_name: "",
          },
        }
      end
      assert_response :unprocessable_content
    end
  end
end
