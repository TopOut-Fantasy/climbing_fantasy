require "test_helper"

class Api::V1::CompetitionsControllerTest < ActionDispatch::IntegrationTest
  test "GET /api/v1/competitions returns all competitions" do
    get api_v1_competitions_path
    assert_response :success

    json = JSON.parse(response.body)
    assert json.key?("data")
    assert json.key?("meta")
    assert_equal Competition.count, json["meta"]["total"]
  end

  test "GET /api/v1/competitions returns expected fields" do
    get api_v1_competitions_path
    json = JSON.parse(response.body)
    comp = json["data"].first

    assert comp.key?("id")
    assert comp.key?("name")
    assert comp.key?("location")
    assert comp.key?("starts_on")
    assert comp.key?("ends_on")
    assert comp.key?("discipline")
    assert comp.key?("status")
  end

  test "GET /api/v1/competitions filters by season_id" do
    season = seasons(:season_2024)
    get api_v1_competitions_path(season_id: season.id)
    json = JSON.parse(response.body)

    json["data"].each do |comp|
      assert_equal season.id, comp["season_id"]
    end
  end

  test "GET /api/v1/competitions filters by discipline" do
    get api_v1_competitions_path(discipline: "boulder")
    json = JSON.parse(response.body)

    json["data"].each do |comp|
      assert_equal "boulder", comp["discipline"]
    end
  end

  test "GET /api/v1/competitions filters by status" do
    get api_v1_competitions_path(status: "completed")
    json = JSON.parse(response.body)

    json["data"].each do |comp|
      assert_equal "completed", comp["status"]
    end
  end

  test "GET /api/v1/competitions filters by year" do
    get api_v1_competitions_path(year: 2024)
    json = JSON.parse(response.body)

    assert json["data"].length > 0
    json["data"].each do |comp|
      assert_equal seasons(:season_2024).id, comp["season_id"]
    end
  end

  test "GET /api/v1/competitions/:id returns competition with categories" do
    comp = competitions(:innsbruck_boulder)
    get api_v1_competition_path(comp)
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal comp.id, json["data"]["id"]
    assert json["data"].key?("categories")
    assert json["data"].key?("season")
  end

  test "GET /api/v1/competitions/:id returns 404 for missing" do
    get api_v1_competition_path(id: 999999)
    assert_response :not_found
  end
end
