require "test_helper"

module Users
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test "GET /login renders login page" do
      get "/login"
      assert_response :success
      assert_select "h2", "Welcome Back"
    end

    test "POST /login signs in with valid credentials" do
      post "/login", params: { user: { email: users(:alice).email, password: "password123456" } }
      assert_redirected_to authenticated_root_path
      follow_redirect!
      assert_response :success
    end

    test "POST /login with invalid credentials shows error" do
      post "/login", params: { user: { email: users(:alice).email, password: "wrong" } }
      assert_response :unprocessable_content
    end

    test "DELETE /logout signs out user" do
      sign_in users(:alice)
      delete "/logout"
      assert_response :redirect
    end
  end
end
