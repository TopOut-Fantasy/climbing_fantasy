require "test_helper"

module Api
  module V1
    class RoundsControllerTest < ActionDispatch::IntegrationTest
      test "GET /api/v1/rounds/:id returns round with results" do
        round = rounds(:keqiao_boulder_men_final)
        get api_v1_round_path(round)
        assert_response :success

        json = response.parsed_body
        assert_equal round.id, json["data"]["id"]
        assert_equal round.name, json["data"]["name"]
        assert json["data"].key?("round_results")
      end

      test "GET /api/v1/rounds/:id includes athlete data in results" do
        round = rounds(:keqiao_boulder_men_final)
        get api_v1_round_path(round)

        json = response.parsed_body
        result = json["data"]["round_results"].first
        assert result.key?("athlete")
        assert result["athlete"].key?("first_name")
        assert result["athlete"].key?("last_name")
      end

      test "GET /api/v1/rounds/:id returns 404 for missing" do
        get api_v1_round_path(id: 999999)
        assert_response :not_found
      end
    end
  end
end
