require "test_helper"

class CompetitionTest < ActiveSupport::TestCase
  test "validates presence of name" do
    comp = Competition.new(season: seasons(:season_2024), location: "X", starts_on: Date.today, ends_on: Date.today, discipline: :boulder, status: :upcoming)
    comp.name = nil
    assert_not comp.valid?
    assert_includes comp.errors[:name], "can't be blank"
  end

  test "validates presence of location" do
    comp = Competition.new(season: seasons(:season_2024), name: "X", starts_on: Date.today, ends_on: Date.today, discipline: :boulder, status: :upcoming)
    comp.location = nil
    assert_not comp.valid?
    assert_includes comp.errors[:location], "can't be blank"
  end

  test "validates presence of starts_on" do
    comp = Competition.new(season: seasons(:season_2024), name: "X", location: "X", ends_on: Date.today, discipline: :boulder, status: :upcoming)
    comp.starts_on = nil
    assert_not comp.valid?
    assert_includes comp.errors[:starts_on], "can't be blank"
  end

  test "validates presence of ends_on" do
    comp = Competition.new(season: seasons(:season_2024), name: "X", location: "X", starts_on: Date.today, discipline: :boulder, status: :upcoming)
    comp.ends_on = nil
    assert_not comp.valid?
    assert_includes comp.errors[:ends_on], "can't be blank"
  end

  test "discipline enum values" do
    assert_equal %w[boulder lead speed combined boulder_and_lead], Competition.disciplines.keys
  end

  test "status enum values" do
    assert_equal %w[upcoming in_progress completed], Competition.statuses.keys
  end

  test "belongs to season" do
    competition = competitions(:innsbruck_boulder)
    assert_equal seasons(:season_2024), competition.season
  end

  test "has many categories" do
    competition = competitions(:innsbruck_boulder)
    assert_includes competition.categories, categories(:innsbruck_boulder_men)
  end
end
