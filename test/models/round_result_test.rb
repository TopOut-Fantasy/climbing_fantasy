require "test_helper"

class RoundResultTest < ActiveSupport::TestCase
  test "validates rank is integer when present" do
    result = RoundResult.new(round: rounds(:innsbruck_boulder_men_final), athlete: athletes(:janja_garnbret))
    result.rank = 1.5
    assert_not result.valid?
    assert_includes result.errors[:rank], "must be an integer"
  end

  test "allows nil rank" do
    result = RoundResult.new(round: rounds(:chamonix_lead_women_final), athlete: athletes(:tomoa_narasaki), rank: nil)
    assert result.valid?
  end

  test "validates boulder integer fields" do
    result = RoundResult.new(round: rounds(:innsbruck_boulder_men_final), athlete: athletes(:janja_garnbret))
    result.tops = 1.5
    assert_not result.valid?
    assert_includes result.errors[:tops], "must be an integer"
  end

  test "unique athlete per round" do
    existing = round_results(:fujii_innsbruck_final)
    duplicate = RoundResult.new(
      round: existing.round,
      athlete: existing.athlete,
      rank: 2,
      score_raw: "duplicate"
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:athlete_id], "has already been taken"
  end

  test "belongs to round" do
    result = round_results(:fujii_innsbruck_final)
    assert_equal rounds(:innsbruck_boulder_men_final), result.round
  end

  test "belongs to athlete" do
    result = round_results(:fujii_innsbruck_final)
    assert_equal athletes(:kokoro_fujii), result.athlete
  end

  test "boulder result attributes" do
    result = round_results(:fujii_innsbruck_final)
    assert_equal 1, result.rank
    assert_equal 4, result.tops
    assert_equal 4, result.zones
    assert_equal 5, result.top_attempts
    assert_equal 4, result.zone_attempts
  end

  test "lead result attributes" do
    result = round_results(:garnbret_chamonix_final)
    assert_in_delta 42.5, result.lead_height
    assert result.lead_plus
  end

  test "speed result attributes" do
    result = round_results(:speed_result)
    assert_in_delta 6.53, result.speed_time
    assert_equal "quarter_final", result.speed_eliminated_stage
  end
end
