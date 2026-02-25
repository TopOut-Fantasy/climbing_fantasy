require "test_helper"

class Ifsc::ResultSyncerTest < ActiveSupport::TestCase
  test "syncs seasons from API response" do
    data = JSON.parse(File.read(Rails.root.join("test/fixtures/files/ifsc_seasons_response.json")))

    assert_difference "Season.count", 1 do
      Ifsc::ResultSyncer.sync_seasons(data)
    end

    season = Season.find_by(external_id: 37)
    assert_equal "IFSC World Cup 2025", season.name
    assert_equal 2025, season.year
  end

  test "syncs seasons idempotently" do
    data = JSON.parse(File.read(Rails.root.join("test/fixtures/files/ifsc_seasons_response.json")))

    Ifsc::ResultSyncer.sync_seasons(data)
    assert_no_difference "Season.count" do
      Ifsc::ResultSyncer.sync_seasons(data)
    end
  end

  test "syncs competitions from season data" do
    data = JSON.parse(File.read(Rails.root.join("test/fixtures/files/ifsc_seasons_response.json")))
    Ifsc::ResultSyncer.sync_seasons(data)

    season = Season.find_by(external_id: 37)
    assert_equal 1, season.competitions.count

    comp = season.competitions.first
    assert_equal "IFSC World Cup Seoul 2025", comp.name
    assert_equal "Seoul, KOR", comp.location
  end

  test "syncs categories from event results" do
    competition = competitions(:innsbruck_boulder)
    data = JSON.parse(File.read(Rails.root.join("test/fixtures/files/ifsc_event_results_response.json")))

    initial_count = competition.categories.count
    Ifsc::ResultSyncer.sync_categories(competition, data)

    assert competition.categories.count > initial_count
  end

  test "syncs round results from category data" do
    category = categories(:innsbruck_boulder_men)
    data = JSON.parse(File.read(Rails.root.join("test/fixtures/files/ifsc_category_results_response.json")))

    Ifsc::ResultSyncer.sync_results(category, data)

    # Should have created/updated results
    assert category.rounds.any?
  end
end
