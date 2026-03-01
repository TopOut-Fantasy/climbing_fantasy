require "test_helper"

module Api
  module V1
    class CategoriesControllerTest < ActionDispatch::IntegrationTest
      test "GET /api/v1/categories/:id returns category with rounds" do
        cat = categories(:keqiao_boulder_men)
        get api_v1_category_path(cat)
        assert_response :success

        json = response.parsed_body
        assert_equal cat.id, json["data"]["id"]
        assert_equal cat.name, json["data"]["name"]
        assert json["data"].key?("rounds")
      end

      test "GET /api/v1/categories/:id returns 404 for missing" do
        get api_v1_category_path(id: 999999)
        assert_response :not_found
      end
    end
  end
end
