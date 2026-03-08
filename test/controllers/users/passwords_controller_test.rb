require "test_helper"

module Users
  class PasswordsControllerTest < ActionDispatch::IntegrationTest
    test "GET /password/new renders forgot password form" do
      get "/password/new"
      assert_response :success
      assert_select "h2", "Forgot Password"
    end

    test "POST /password sends reset email for existing user" do
      post "/password", params: { user: { email: users(:alice).email } }
      assert_redirected_to "/login"
    end
  end
end
