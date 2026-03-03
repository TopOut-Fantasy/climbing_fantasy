require "test_helper"

class ClimbResultTest < ActiveSupport::TestCase
  test "topped? is true when top_attempts is greater than zero" do
    assert climb_results(:anraku_keqiao_p1).topped?
  end

  test "topped? is false when top_attempts is zero" do
    assert_not climb_results(:thomas_nsw_p2).topped?
  end

  test "zoned? is true when zone_attempts is greater than zero" do
    assert climb_results(:anraku_keqiao_p1).zoned?
  end

  test "zoned? is false when zone_attempts is zero" do
    assert_not climb_results(:thomas_nsw_p2).zoned?
  end

  test "high_zoned? is true when high_zone_attempts is greater than zero" do
    climb_result = ClimbResult.new(top_attempts: 0, zone_attempts: 0, high_zone_attempts: 1)
    assert climb_result.high_zoned?
  end

  test "high_zoned? is false when high_zone_attempts is nil" do
    climb_result = ClimbResult.new(top_attempts: 0, zone_attempts: 0, high_zone_attempts: nil)
    assert_not climb_result.high_zoned?
  end

  test "low_zone_attempts aliases zone_attempts" do
    climb_result = climb_results(:anraku_keqiao_p2)
    assert_equal climb_result.zone_attempts, climb_result.low_zone_attempts
  end
end
