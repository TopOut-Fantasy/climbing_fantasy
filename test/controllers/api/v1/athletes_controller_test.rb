require "test_helper"

module Api
  module V1
    class AthletesControllerTest < ActionDispatch::IntegrationTest
      test "GET /api/v1/athletes returns paginated athletes" do
        get api_v1_athletes_path
        assert_response :success

        json = response.parsed_body
        assert json.key?("data")
        assert json.key?("meta")
        assert_equal Athlete.count, json["meta"]["total"]
      end

      test "GET /api/v1/athletes searches by name" do
        get api_v1_athletes_path(q: "anraku")
        json = response.parsed_body

        assert_equal 1, json["data"].length
        assert_equal "Anraku", json["data"].first["last_name"]
      end

      test "GET /api/v1/athletes searches case-insensitively" do
        get api_v1_athletes_path(q: "ANRAKU")
        json = response.parsed_body

        assert_equal 1, json["data"].length
      end

      test "GET /api/v1/athletes filters by country" do
        get api_v1_athletes_path(country: "JPN")
        json = response.parsed_body

        assert_not json["data"].empty?
        json["data"].each do |athlete|
          assert_equal "JPN", athlete["country_code"]
        end
      end

      test "GET /api/v1/athletes/:id returns athlete with recent results" do
        athlete = athletes(:sorato_anraku)
        get api_v1_athlete_path(athlete)
        assert_response :success

        json = response.parsed_body
        assert_equal athlete.id, json["data"]["id"]
        assert_equal athlete.first_name, json["data"]["first_name"]
        assert json["data"].key?("round_results")
      end

      test "GET /api/v1/athletes/:id returns 404 for missing" do
        get api_v1_athlete_path(id: 999999)
        assert_response :not_found
      end
    end
  end
end
